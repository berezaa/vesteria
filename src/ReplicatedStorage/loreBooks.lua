



local library = {
	["Mississippi's Journal"] = {
		{text = "Day 1\n\nWell, we made it into the Whispering Dunes after negotiating with the bandits. Who knows how long it's been since someone from the three factions has reached this place? Even the Mages seem to have forgotten it. Put bluntly, the region is massive. Who knows if I'll ever be able to explore it all?"},
		{text = "Day 5\n\nI can't say I've been sleeping particularly well. The locals call this place the Whispering Dunes because, apparently, spirits in the night will whisper their final regrets. I dismissed it as superstitious nonsense, but the nightmares I've been having... and that place. I can't get it out of my head."},
		{text = "Day 22\n\nIt took some time, but I finally found it. Small groups of bandits go there at night. I wonder if their dreams are disturbed, too? It appears to have been a palace, but it's now buried in sand. According to local legend, it was once ruled by a powerful mage called Tal-rey. The nightmares won't stop."},
		{text = "it must be me\n\nhaven't slept in days\nthe dreams keep coming, more and more terrible, more and more wonderful\ni must be the only one, i'm special\ni am his return\ni'm him\ni'm tal-rey\ni'm him i'm him i'm him i'm him i'm him i'm him"},
	},
		
		
		["Evil Journal"] = {
			{text = "HAAHAAHAAA! THAT FOOL MOBEUS! WHAT A FUNNY GUY! I WAS JUST LOUNGING AT THE BEACH, SOAKING IN THE BEAUTIFUL VESTERIAN SUN RAYS WHEN I HEARD THE BOY MUMBLING TO HIMSELF! HAHAHAHA! A WHALE HUNTER HE SAID HE WANTED TO BE!"}, 
				
			{text = "I TOLD THE BOY YES OF COURSE I CAN HELP YOU BECOME A WHALE HUNTER! I KNOW THE INITIATION PROCESS! JUST A SIMPLE POTION TO BECOME BIG AND STRONG, THAT'S ALL IT TAKES! HERE YOU GO MOBEUS... POOF!"},{text = "WELCOME TO THE FACTION OF WHALE HUNTERS, YOU SLIPPERY SEA MAMMAL YOU! HAVE FUN IN THE BAY SWIMMING AROUND AND DOING YOUR FUN WHALE THINGS!"; 
				
				openFunc = function(util)
					local playerQuests = util.network:invoke("getCacheValueByNameTag", "quests")
							for i, quest in pairs(playerQuests.active) do
								if quest.id == 8 then
									if quest.currentObjective == 2 and quest.objectives[2].started and quest.objectives[2].steps[2].completion.amount == 0 then
										util.network:invokeServer("playerRequest_readEvilJournal") -- needs to yield
										util.network:fire("MobeusDialogueEnable")
									end
								end
							end
				end};
			
		};
		
		["Drowned Note - Crossroads"] = {
			{text = "Aha! MELVIN, YOU ARE A GENIUS! Who needs a bank when you can hide all your belongings in a confusing underwater tunnel system? Any thief will surely drown! Now I just- wait a second. How do I get out of here? Which way is it?!?"}
		};
			
		["Yeti cave note"] = {
			{text = "I'm alive! The yeti wasn’t able to reach me inside this hole and eventually gave up trying. Now I just have to wait for him to let his guard down... maybe I’ll take a nap to pass the time..."}
		};
}
	
	
	





local books = {} 

function books.getBook(name)
	if library[name] then
		return library[name]
	end
	return { {text = "book does not exist"} }
end

return books