scenario = "selfpaced.sce";		# name of scenario
pcl_file = "selfpaced.pcl";    # open associated PCL file
no_logfile = false;							# save a logfile
	
default_background_color = 200, 200, 200;		# gray background
default_text_color = 0, 0, 0;		# black text
default_font_size = 14;						# medium font
default_font = "Courier New";

active_buttons = 3;		
button_codes = 1, 2, 3; 					# 1 is A, 2 is left, 3 is right

		# condition ; iteminfo + ";" + boundinfo + ";" + quantinfo + ";" + string(region) + ";" + sentence[region]
stimulus_properties = Item, string, Boundedness, string, Quantifier, string, RegionNumber, string, RegionDisplayed, string, OrderInExperiment, string;
event_code_delimiter = ";";


 

begin;

trial {				#-----------------   INSTRUCTIONS   -----------------                       
   trial_type = correct_response;
   trial_duration = forever;
	picture {                                    
		text { caption =
"The main experiment is going to begin. It is divided
into 6 blocks, and you can take breaks between blocks.\n
Let the experimenter know now if you have any questions.
Otherwise, press A to begin.";
			text_align = align_left; font_size=18;};
		x = 0; y = 0;
	};
   time = 0;
   target_button = 1;
} instruction_trial;




trial {				#-----------------   Jittered pause   -----------------                       
   trial_type = fixed;
   trial_duration = 'int(1000 + (250 - (250 * $random_value) ))';	#	Random duration between 750 and 1250
		picture {         
			text { caption = " ";};
			x = 0; y = 0;	
		};
	
} ITI;

trial {				#-----------------   SHOW SENTENCE   -----------------                       
   trial_type = correct_response;
   trial_duration = forever;
	stimulus_event {
		picture {         
			text { caption = " "; preload = false; text_align = align_left;} show_sentence_caption;
			x = 0; y = 0;	
		}show_sentence_picture;
	target_button = 1;
	}show_sentence_event;
	
} show_sentence;

trial {				#-----------------   test   -----------------                       
   trial_type = correct_response;
   trial_duration = forever;
	stimulus_event {
		picture {         
			text { caption = " "; preload = false; text_align = align_center;} test_caption;
			x = 0; y = 0;
		}test_picture;
	target_button = 1;
	}test_event;
	
} test;

trial {				#-----------------   BLOCK END   -----------------               
   trial_type = correct_response;			# present end-of-block (or end-of-experiment) message
   trial_duration = forever;
   
		picture { 
			text { caption = " ";				# message will be loaded from PCL
				text_align = align_left; } block_end_message; 
			x = 0; y = 0;
		} break;
		time = 0;
		target_button = 1;
   
} block_end_trial; 


trial {				#-----------------   SHOW COMPREHENSION QUESTION   -----------------                       
   trial_type = first_response;
   trial_duration = forever;
	stimulus_event {
		picture {                                    
			text { caption = " "; preload = false; } show_compq_caption;
			x = 0; y = 0;							# will be loaded from PCL

			text { caption = " "; preload = false; } show_left_caption;
			x = -250; y = -250;

			text { caption = " "; preload = false; } show_right_caption;
			x = 250; y = -250;
		} ;
	} show_compq_event;
} show_compq; 
