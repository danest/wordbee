$(document).ready(function(){
  // do stuff here now
  mode = "easy"
  app = {
    makeWord: function(){
      $.ajax({
        url: '/word/'+app.addOne(),
        success: function(data, xhr){
          //console.log(data);
          app.addWord(data);
        //alert(data.name);
        //console.log(xhr);
        },
        error: function(data){
        //console.log(data.status);
        }
      });
    },

    addWord: function(data){
      $('#speech').html(data.speech);
      $('#definition').html(data.definition);
      $('#word').html(data.word).data('currentword',data.word);
	  $('input#word').val(app.word_mode(mode,data.word));
    },

	chooseMode: function(){
	  $("#levels span").click(function(){
		//console.log(this);
		$("#levels span.active").removeClass('active');
		var text = $(this).attr('id');
		if(text === 'hard')
			mode = 'hard';
		else if(text == 'medium')
			mode = 'medium'
		else
			mode = 'easy'
		$(this).addClass('active');
		app.makeWord();
	});
	},

	word_mode: function(current_mode,data){
		if(current_mode == "easy"){
			return data.substring(0,3);
		}
		if(current_mode == "medium"){
			return data.substring(0,2);
		}
		if(current_mode == "hard"){
			return data.substring(0,1);
		}
	},
	
    addOne: function(){
      var current = 1;
      //return an object
      return (function(){
          current = Math.floor(Math.random()*1270) + 1;
          return current;
      })();
   }
}

	//check word and add points to score
  $("#checkword").submit(function(e){
	var inputword = $('input#word').val().toLowerCase();
	if (inputword === ''){
		e.preventDefault();
	    return;
	}
    //console.log($('input#word').val());
    //console.log($('#word').data('currentword'))
    if(inputword === $('#word').data('currentword').toLowerCase()){
      //console.log('+10');
	  var points = parseInt($("#points").text());
	  points +=10;
	  $("#points").text(points.toString());
	  $("#wrong").text("Correct answer, you recieved 10 points");
    } else {
	  $("#wrong").text("Sorry wrong answer");
    }
	$("#wrong").effect("highlight", {}, 1500);
    app.makeWord();
    $('input#word').val('');
    e.preventDefault();
  });




var app = app;
  app.chooseMode();
  //var num = app.addOne();

  //generate one word at page load
  //FIX when current = 0?
	$('#choose').click(function(){
	   $('#levels').slideDown();
	});
	
	$('#close').click(function(){
		$('#levels').slideUp();
	});

	$('#start').click(function(){
	  app.makeWord()
	});
	
});


