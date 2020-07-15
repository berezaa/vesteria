local dialogue = {
	id 			= "startTalkingTo";
	dialogue 	= {{text = "hi! eeeeee squeak! im the prettiest gnome girl in the whole gnome town!"}};
	sound = "npc_female_laugh_tiny";
	options 	= {
		
		{
			response 	= "Gnoma is prettier";
			dialogue = {{text = "whaaaattttt? no meeeee!"}};

		};
		
		{
			response 	= "Ok, but...";
			dialogue = {{text = "but what?"}};
			options 	= {
				{
					response 	= "There's more to life than good looks";
					dialogue = {{text = "... wha.. really?"}};
				};
			};
		};
	
	};
}
return dialogue