# Word Bee - Sinatra Text Game

Word Bee is a text based game written in ruby with the Sinatra framework. This is a single page app with Sinatra/Ruby being used as the backend to fetch the words. The rest of the application interacts with jQuery for all the Ajax and small animations. I also used DataMapper for the ORM to help store the data.

The point of this game is that it gives you a definition and part of speech of a word. You are then to guess what the word is. You can also choose from three different levels/modes. Easy will show the first three letter, medium will show the first two and hard will only show one letter. 

I get my words and definitions from http://www.thefreedictionary.com/dictionary.htm 

## TODO

- fix code to retrieve new words
- allows for scores to be saved and displayed with a username
- fix some design elements on the page
- show answers or a list of words you have done already