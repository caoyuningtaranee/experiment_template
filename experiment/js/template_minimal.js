function advanceWord(word_id) {
  console.log("got in here "+word_id);
  $(".sprword").hide();
  $(".sprword").css('visibility','hidden');
  $("#"+word_id).show();
  $("#"+word_id).css('visibility','visible');
  // the 1st and 3rd lines were hidden, need to ask how this works
  exp.word_start = Date.now();
}

function make_slides(f) {
  var   slides = {};

/* For Ling245, no need to change the code
 for i0 and consent slides*/
  slides.i0 = slide({
     name : "i0",
     start: function() {
      exp.startT = Date.now();
     }
  });

  slides.consent = slide({
     name : "consent",
     start: function() {
      exp.startT = Date.now();
      $("#consent_2").hide();
      exp.consent_position = 0;
     },
    button : function() {
      if(exp.consent_position == 0) {
         exp.consent_position++;
         $("#consent_1").hide();
         $("#consent_2").show();
      } else {
        exp.go(); //use exp.go() if and only if there is no "present" data.
      }
    }
  });

/*Consult the code in the consent slide if you
  want to break down very long instructions */
  slides.instructions = slide({
    name : "instructions",
    button : function() {
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });

      slides.practicetrial = slide({
        name : "practicetrial",
        present : exp.prac_stims,
        start : function() {
         $(".err").hide();
         // $("#prac_comque").hide();
         $('input[name="answer"]').prop('checked',false);
        },
        present_handle : function(stim) {
          console.log(stim);
          $(".err").hide();
          $("#prac_compreque").hide();
          $("#padvancebutton").hide();
          $("#prac_space").show();
          this.trial_start = Date.now();
          exp.word_counter = 0;
          _s.rts = [];
          this.stim = stim;

          var sentence = stim.sentence;
          sentence = sentence.filter(function(a) {return a !== ""});
          var sentencehtml = "<p>";
          for (i=0;i<sentence.length;i++) {
            sentencehtml = sentencehtml + '<span id="pw'+(i+1)+'" class="sprword">'+sentence[i]+'</span>';
          }
          sentencehtml = sentencehtml + "</p>";
          $("#prac_sentence").html(sentencehtml);
          console.log("sentencehtml");
          console.log(sentencehtml);

          document.body.onkeyup = function(e){
            if(e.keyCode == 32){
              _s.rts.push(Date.now()-exp.word_start);
              exp.word_counter++;
              if (exp.word_counter <= sentence.length) {
                $("#prac_space").hide();
                advanceWord("pw"+exp.word_counter);
              } else if (stim.comque != ""){
                $(".sprword").hide();
                $('input[id=answer1]').attr('checked',false);
                $('input[id=answer2]').attr('checked',false);
                // do I need "this." here?
                $("#prac_comque").html(stim.comque);
                $("#prac_answer1lab").html(stim.answer1);
                $("#prac_answer2lab").html(stim.answer2);
                $("#prac_compreque").show();
                $("#padvancebutton").show();
              } else {
                $(".sprword").hide();
                $("#padvancebutton").show();
                $(".err").hide()
              }
            }
          }
        },
        button : function() {
          var ok_to_go_on = true;
          if ($('input[name="answer"]:checked').val() == undefined && this.stim.answer1 != "") {
            ok_to_go_on = false;
            $(".err").show();
          } else {
            this.log_responses();
            _stream.apply(this);
          }
        },
        log_responses : function() {
          if ($('input[id="answer1"]:checked').val() =='on') {
            answer = this.stim.answer1
          } else {
            answer = this.stim.answer2
          }
            exp.data_trials.push({
              "type" : this.stim.type,
              "condition" : this.stim.condition,
              "segment4" : this.stim.segment4,
              "slide_number_in_experiment" : exp.phase,
              "sentence" : this.stim.sentence,
              "complete_sentence" : this.stim.complete_sentence,
              "rt" : Date.now() - _s.trial_start,
              "answer" : answer,
              "response": _s.rts, //.concat($('input[name="answer"]:checked').val()),
              "corans" : this.stim.corans,
            });
        }
      });
  slides.transition = slide({
    name : "transition",
    button : function() {
      exp.go(); //use exp.go() if and only if there is no "present" data.
        }
      });

  slides.critical = slide({
    name : "critical",
    present : exp.trial_stims,
    start : function() {
	   $(".err").hide();
     // $("#comque").hide();
     $('input[name="answer"]').prop('checked',false);
    },
    present_handle : function(stim) {
      console.log(stim);
      $(".err").hide();
      $("#space").show();
      $("#compreque").hide();
      $("#advancebutton").hide();
    	this.trial_start = Date.now();
      exp.word_counter = 0;
      _s.rts = [];
      this.stim = stim;

      var sentence = stim.sentence;
      sentence = sentence.filter(function(a) {return a !== ""});
      console.log(sentence);
      var sentencehtml = "<p>";
      for (i=0;i<sentence.length;i++) {
        sentencehtml = sentencehtml + '<span id="w'+(i+1)+'" class="sprword">'+sentence[i]+'</span>';
      }
      sentencehtml = sentencehtml + "</p>";
      $("#sentence").html(sentencehtml);
      console.log("sentencehtml");
      console.log(sentencehtml);

      document.body.onkeyup = function(e){
        if(e.keyCode == 32){
          _s.rts.push(Date.now()-exp.word_start);
          exp.word_counter++;
          if (exp.word_counter <= sentence.length) {
            $("#space").hide();
            advanceWord("w"+exp.word_counter);
          } else if (stim.comque != ""){
            $(".sprword").hide();
            $('input[id=answer1]').attr('checked',false);
            $('input[id=answer2]').attr('checked',false);
            $("#comque").html(stim.comque);
            $("#answer1lab").html(stim.answer1);
            $("#answer2lab").html(stim.answer2);
            $("#compreque").show();
            $("#advancebutton").show();
          } else {
            $(".sprword").hide();
            $("#advancebutton").show();
            $(".err").hide()
          }
        }
      }
    },
    button : function() {
      var ok_to_go_on = true;
      if ($('input[name="answer"]:checked').val() == undefined && this.stim.answer1 != "") {
        ok_to_go_on = false;
        $(".err").show();
      } else {
        this.log_responses();
        _stream.apply(this);
      }
    },
    log_responses : function() {
      if ($('input[id="answer1"]:checked').val() =='on') {
        answer = this.stim.answer1
      } else {
        answer = this.stim.answer2
      }
        exp.data_trials.push({
          "type" : this.stim.type,
          "condition" : this.stim.condition,
          "segment4" : this.stim.segment4,
          "slide_number_in_experiment" : exp.phase,
          "sentence" : this.stim.sentence,
          "complete_sentence" : this.stim.complete_sentence,
          "rt" : Date.now() - _s.trial_start,
          "answer" : answer,
          "response": _s.rts, //.concat($('input[name="answer"]:checked').val()),
          "corans" : this.stim.corans,
        });
    }
  });

  slides.subj_info =  slide({
    name : "subj_info",
    submit : function(e){
      //if (e.preventDefault) e.preventDefault(); // I don't know what this means.
      exp.subj_data = {
        language : $("#language").val(),
        enjoyment : $("#enjoyment").val(),
        asses : $('input[name="assess"]:checked').val(),
        age : $("#age").val(),
        gender : $("#gender").val(),
        education : $("#education").val(),
        comments : $("#comments").val(),
        problems: $("#problems").val(),
      };
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });

  slides.thanks = slide({
    name : "thanks",
    start : function() {
      exp.data= {
          "trials" : exp.data_trials,
          "catch_trials" : exp.catch_trials,
          "system" : exp.system,
          "condition" : exp.condition,
          "subject_information" : exp.subj_data,
          "time_in_minutes" : (Date.now() - exp.startT)/60000
      };
      setTimeout(function() {turk.submit(exp.data);}, 1000);
    }
  });

  return slides;
}

/// init ///
function init() {
  repeatWorker = false;
  (function(){
    var ut_id = "taranee-politzer2013";
    if (UTWorkerLimitReached(ut_id)) {
      $('.slide').empty();
      repeatWorker = true;
      alert("You have already completed the maximum number of HITs allowed by this requester. Please click 'Return HIT' to avoid any impact on your approval rating.");
    }
  })();
  //specify conditions. Decide between-subject conditions, most important part here
  // exp.condition = _.sample(["comparatives", "multiple negations"]); //can randomize between subject conditions here
  //blocks of the experiment:
  exp.structure=["i0", "consent", "instructions", "practicetrial", "transition", "critical", 'subj_info', 'thanks'];
  // exp.structure=["i0", "consent", "instructions","transition", "critical", 'subj_info', 'thanks'];

  function makeStim(i) {

    var condition = _.sample([" all of them "," any of them "]);
    var sentence = stimuli[i];

    //segment 4
    if (sentence.type != "critical") {
      var segment4 = sentence.segment4;
    } else {
      var segment4 = _.sample([" some of them "," only some of them "]);
    }
    //segment2
    if (sentence.type == "critical") {
      var segment2 = sentence.segment2a + condition + sentence.segment2b;
    } else {
      var segment2 = sentence.segment2;
    }
    //comprehension
    var comque = sentence.comque
    var answer1 = _.sample([sentence.corans, sentence.incorans])
    if (answer1 == sentence.corans) {
      var answer2 = sentence.incorans
    } else {
      var answer2 = sentence.corans
    }

    var  stimuli_sentence = sentence.segment1 + segment2 + sentence.segment3 +
    segment4 + sentence.segment5 + sentence.segment6 + sentence.segment7 +
    sentence.segment8 + sentence.segment9 + sentence.segment10 + sentence.segment11 +
    sentence.segment12

    var full_sentence = [sentence.segment1, segment2, sentence.segment3,
    segment4, sentence.segment5, sentence.segment6, sentence.segment7,
    sentence.segment8, sentence.segment9, sentence.segment10, sentence.segment11,
    sentence.segment12];

    exp.all_stims.push({
        "condition": condition,
        "segment4": segment4,
        "type": sentence.type,
        "segment1": sentence.segment1,
        "segment2": segment2,
        "segment3": sentence.segment3,
        "segment4": segment4,
        "segment5": sentence.segment5,
        "segment6": sentence.segment6,
        "segment7": sentence.segment7,
        "segment8": sentence.segment8,
        "segment9": sentence.segment9,
        "segment10": sentence.segment10,
        "segment11": sentence.segment11,
        "segment12": sentence.segment12,
        "comque": sentence.comque,
        "corans": sentence.corans,
        "answer1": answer1,
        "answer2": answer2,
        "sentence": full_sentence,
        "complete_sentence": stimuli_sentence
        });
  };

  exp.all_stims = [];
  for (var i=0; i<stimuli.length; i++) {
    makeStim(i);
  }
  exp.trial_stims = exp.all_stims.filter(function(a){return a.type != "practice"})
  exp.trial_stims = _.shuffle(exp.trial_stims)
  exp.prac_stims = exp.all_stims.filter(function(a){ return a.type == "practice"; })
  exp.prac_stims = _.shuffle(exp.prac_stims)
  // console.log(exp.prac_stims.slice(0).sentence)

  // generally no need to change anything below
  exp.trials = [];
  exp.catch_trials = [];
  exp.data_trials = [];
  exp.system = {
      Browser : BrowserDetect.browser,
      OS : BrowserDetect.OS,
      screenH: screen.height,
      screenUH: exp.height,
      screenW: screen.width,
      screenUW: exp.width
    };

  //make corresponding slides:
  exp.slides = make_slides(exp);

  exp.nQs = utils.get_exp_length(); //this does not work if there are stacks of stims (but does work for an experiment with this structure)
                    //relies on structure and slides being defined

  $('.slide').hide(); //hide everything

  //make sure turkers have accepted HIT (or you're not in mturk)
  $("#start_button").click(function() {
    if (turk.previewMode) {
      $("#mustaccept").show();
    } else {
      $("#start_button").click(function() {$("#mustaccept").show();});
      exp.go();
    }
  });

  exp.go(); //show first slide
}
