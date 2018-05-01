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

    // make sure participants understand
    // the task before they continue
      // response = $("#text_response").val();
      // if (response.length == 0) {
      //   $(".err").show();
      // } else {
      //   exp.data_trials.push({
      //     "trial_type" : "example",
      //     "response" : response
      //   });
      //   exp.go(); //make sure this is at the *end*, after you log your data
      // }

  slides.critical = slide({
    name : "critical",
    present : exp.all_stims,
    start : function() {
	   $(".err").hide();
     // $('input[name="tf"]').prop('checked',false);
     // $('no').prop('checked',false);
    },
    present_handle : function(stim) {
      console.log(stim);
      $(".err").hide();
      $("#truefalse").hide();
      $("#advancebutton").hide();
    	this.trial_start = Date.now();
      exp.word_counter = 0;
      _s.rts = [];
      this.stim = stim;

      var sentence = stim.sentence;
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
          if (exp.word_counter <= stim.sentence.length) {
            advanceWord("w"+exp.word_counter);
          } else {
            $(".sprword").hide();
            $('input[id=yes]').attr('checked',false);
            $('input[id=no]').attr('checked',false);
            $("#truefalse").show();
            $("#advancebutton").show();
          }
        }
      }
    },
    button : function() {
      var ok_to_go_on = true;
      if ($('input[name="tf"]:checked').val() == undefined) {
        ok_to_go_on = false;
        $(".err").show();
      } else {
        this.log_responses();
        _stream.apply(this);
      }
    },
    log_responses : function() {
        exp.data_trials.push({
          "item" : this.stim.item,
          "slide_number_in_experiment" : exp.phase,
          "sentence": this.stim.sentence,
          "sentence_type": this.stim.sentence_type,
          "quantifier": this.stim.quantifier,
          "rt" : Date.now() - _s.trial_start,
          "response" : _s.rts.concat($('input[name="tf"]:checked').val())
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
  //specify conditions. Decide between-subject conditions, most important part here
  // exp.condition = _.sample(["comparatives", "multiple negations"]); //can randomize between subject conditions here
  //blocks of the experiment:
  exp.structure=["i0", "consent", "instructions", "critical", 'subj_info', 'thanks'];

  function makeStim() {
    // I deleted the argument "sentence" in makeStim(sentence)
    var condition = _.shuffle(["all","any"]);
    var segment4 = _.shuffle(["some of them","only some of them"]);
    //get item
    var sentence = stimuli[0];
    // var segment1 = sentence.segment1;
    if (sentence.type == "critical") {
      var segment2 = sentence.segment2a + condition + sentence.segment2b;
    } else {
      var segment2 = sentence.segment2;
    }
    var comque = sentence.comque
    var answer1 = _.shuffle([sentence.corans, sentence.incorans])
    if (answer1 == sentence.corans) {
      var answer2 = sentence.incorans
    } else {
      var answer2 = sentence.corans
    }

    var  stimuli_sentence = sentence.segment1 + segment2 + sentence.segment3 +
    segment4 + sentence.segment5 + sentence.segment6 + sentence.segment7 +
    sentence.segment8 + sentence.segment9 + sentence.segment10 + sentence.segment11 +
    sentence.segment12

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
        "answer1": answer1
        "answer2": answer2
        });
  };
//Shouldn't I put this empty list before makeStim?
    exp.all_stims = [];

    // for (var i = 0; i < stimuli.length; i++) {
    //   makeStim(stimuli[i]);
    // };
    // No loop at the moment. Just displaying one sentence.

    console.log(exp.all_stims);

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
