/// init ///
function init() {

  var names = _.shuffle([

  ]);

  var items = _.shuffle([


  ]);//.slice(0,36) -- what does this mean?;

  function makeStim(i) {
    var quantifiers = _.shuffle(["Some","All","None"]);
    var sentence_type = _.shuffle(["true","false"]);
    //get item
    var name_data = names[i];
    var name = name_data.name;
    var gender = name_data.gender;
    var item = items[i];
    var item_id = item.item;
    var contextsentence = item.contextsentence;
    var order = item.fixedorder;

    for (var j=0; j<sentence_type.length;j++) {
      var sentence_start = [name, "says: "];
      // var contents = _.shuffle(["content1","content2","content3"]);

      if (sentence_type[j] == "true") {
        if (quantifiers[j] == "All") {
          sentence = sentence_start.concat(["All", "of", "these", item.noun, "have", order[0], "in", "them"]);
        } else {
          if (quantifiers[j] == "Some") {
            sentence = sentence_start.concat(["Some", "of", "these", item.noun, "have", order[1], "in", "them"]);
          } else {
            sentence = sentence_start.concat(["None", "of", "these", item.noun, "have", item.content0, "in", "them"]);
          }
        }
      } else {
        if (sentence_type[j] == "false") {
          if (quantifiers[j] == "All") {
            sentence = sentence_start.concat(["All", "of", "these", item.noun, "have", item.content0, "in", "them"]);
          } else {
            if (quantifiers[j] == "Some") {
              sentence = sentence_start.concat(["Some", "of", "these", item.noun, "have", item.content0, "in", "them"]);
            } else {
              sentence = sentence_start.concat(["None", "of", "these", item.noun, "have", order[0], "in", "them"]);
            }
          }
        }
      }
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
