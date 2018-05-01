/// init ///
function init() {

  //.slice(0,36) -- what does this mean?;
  // stimuli = a list of dictionaries, see the .json file

  function makeStim(i) {
    var condition = _.shuffle(["all","any"]);
    var segment4 = _.shuffle(["some of them","only some of them"]);
    //get item
    var sentence = stimuli[i];
    var segment1 = sentence.segment1;
    if (sentence.type == "critical") {
      var segment2 = sentence.segment2a + condition + sentence.segment2b;
    } else {
      var segment2 = sentence.segment2;
    }
    var segment3 = sentence.segment3
    var segment4 = sentence.segment5
    var segment6 = sentence.segment6
    var segment7 = sentence.segment7
    var segment8 = sentence.segment8
    var segment9 = sentence.segment9
    var segment10 = sentence.segment10
    var segment11 = sentence.segment11
    var segment12 = sentence.segment12
    var comque = sentence.comque
    var answer1 = _.shuffle([sentence.corans, sentence.incorans])
    if (answer1 == sentence.corans) {
      var answer2 = sentence.incorans
    } else {
      var answer2 = sentence.corans
    }
    var corans = sentence.corans

    for (var j=0; j<stimuli.length;j++) {
      stimuli_sentence = segment1+segment2+segment3+segment4+segment5+segment6+segment7+segment8+segment9+segment10+segment11+segment12
      
  exp.all_stims.push( {
      "item": item_id,
      "noun" : item.noun,
      "contextsentence": contextsentence,
      "sentence": sentence,
      "name": name,
      "gender": gender,
      "sentence_type" : sentence_type[j],
      "quantifier" : quantifiers[j]
    });
}
     exp.all_stims.push( {
      "item": item_id,
      "noun" : item.noun,
      "contextsentence": contextsentence,
      "sentence": sentence_start.concat(["Some","of","these",item.noun,"have",order[0],"in","them"]),
      "name": name,
      "gender": gender,
      "sentence_type" : "underinformative",
      "quantifier" : "Some"
    });
      exp.all_stims.push( {
      "item": item_id,
      "noun" : item.noun,
      "contextsentence": contextsentence,
      "sentence": sentence_start.concat(["Some","of","these",item.noun,"have",order[2],"in","them"]),
      "name": name,
      "gender": gender,
      "sentence_type" : "atypical",
      "quantifier" : "Some"
    });
  }
  exp.all_stims = [];
  for (var i=0; i<items.length; i++) {
    makeStim(i);
  }

  exp.trials = [];
  exp.catch_trials = [];
  exp.condition = {}; //can randomize between subject conditions here
  exp.system = {
      Browser : BrowserDetect.browser,
      OS : BrowserDetect.OS,
      screenH: screen.height,
      screenUH: exp.height,
      screenW: screen.width,
      screenUW: exp.width
    };
  //blocks of the experiment:
  exp.structure=["i0", "practicetrial", "sprtrial", 'subj_info', 'thanks'];

  exp.data_trials = [];
  //make corresponding slides:
  exp.slides = make_slides(exp);

  exp.nQs = utils.get_exp_length(); //this does not work if there are stacks of stims (but does work for an experiment with this structure)
                    //relies on structure and slides being defined
  $(".nQs").html(exp.nQs);

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
