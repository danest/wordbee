require 'sinatra'
require 'data_mapper'
require 'json'
require 'nokogiri'
require 'open-uri'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/wordbee.db")

class Word
  include DataMapper::Resource
  property :id, Serial
  property :speech, Text, :required => true
  property :word, Text, :required => true
  property :definition, Text, :required => true
  property :created_at, DateTime  
  property :updated_at, DateTime  
end

DataMapper.finalize.auto_upgrade!

get '/' do
  erb :index
end

get '/word/:id' do
    content_type :json
    @word = Word.get params[:id]
    {
      :word => @word.word,
      :speech => @word.speech,
      :definition => @word.definition
    }.to_json
end

get '/lookup/:w' do
  content_type :json
  @word = Word.all(:word.like => params[:w].lower)
  { :word => @word }.to_json  
end

get '/makeword' do
    #TODO move this into its own class
    url = "http://www.thefreedictionary.com/dictionary.htm"
    doc = Nokogiri::HTML(open(url, 'User-Agent' => 'ruby'))
    #map all the words to extract the def
    #40 random words at once
    doc.css(".box1 td a").map{ |word|

      puts word.text.capitalize
      #sleep the script or else the server detects and sends a 403 forbidden response
      sleep 5
      url ="http://www.thefreedictionary.com/" + word
      doc = Nokogiri::HTML(open(url))
      #puts doc.at_css(".ds-single").text
      if(doc.at_css(".sds-list") && doc.at_css(".ds-list") == nil )
        definition =  doc.at_css(".sds-list").text
      elsif(doc.at_css(".ds-list") && doc.at_css(".ds-single") == nil)
        definition = doc.at_css(".ds-list").text
      elsif(doc.at_css(".sds-list") && doc.at_css(".ds-list"))
        definition = doc.at_css(".ds-list").text
      else
        definition = doc.at_css(".ds-single").text
      end

      if definition.include? "1. a.  "
        #puts definition
        definition = definition[7, definition.length]
      elsif definition.include? "1. "
       # puts definition
        definition = definition[3, definition.length]
      end

      puts definition.strip


      if(doc.at_css("div i").text.strip == "n.")
        speech =  "Noun"
      elsif(doc.at_css("div i").text.strip == "adj.")
         speech =  "Adjective"
      elsif(doc.at_css("div i").text.strip == "v.")
         speech =  "Verb"
      elsif(doc.at_css("div i").text.strip == "pron.")
         speech =   "Pronoun"
      elsif(doc.at_css("div i").text.strip == "adv.")
         speech =   "Adverb"
      elsif(doc.at_css("div i").text.strip == "prep.")
         speech =   "Preposition"
      elsif(doc.at_css("div i").text.strip == "conj.")
          speech =   "Conjunction"
      elsif(doc.at_css("div i").text.strip == "interj.")
          speech =   "Interjection"
      elsif(doc.at_css("div i").text.strip == "tr.v.")
         speech =   "Transitive Verb"
      elsif(doc.at_css("div i").text.strip == "abbr.")
         speech =   "Abbreviation"
      elsif(doc.at_css("div i").text.strip == "intr.v.")
         speech =   "Intransitive Verb"
      else
         speech =   nil
      end

      if speech
        w = Word.new
        w.speech = speech
        w.word = word.text.capitalize
        w.definition = definition
        w.created_at = Time.now
        w.updated_at = Time.now
        w.save
        # db.execute( "INSERT OR REPLACE into words values (?, ?, ?, ? )",nil, speech, word.text.capitalize, definition)
      end
 }
  redirect '/'
end
