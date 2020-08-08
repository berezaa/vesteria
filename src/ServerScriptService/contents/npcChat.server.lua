-- single script to handle all the npc chat bubbles

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	local utilities			= modules.load("utilities")
	
	
network:create("syncedNPCChat","RemoteEvent")


	
local mapSpecificChat = {
		-- Mushtown
		["2064647391"] = {
			["Rough Ruth"] = {
				lines = {"Mushtown is so boring...", "Hey, who are you looking at?", "Dumb chickens."};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {20,70};
			};
			["Mayor Noah"] = {
				lines = {"What to do, what to do...", "Sigh... always something going wrong 'round here.", "This job ain't easy."};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {20,90};
				};
			["Shopkeeper"] = {
				lines = {"Fine goods for sale!", "The finest goods in all of Vesteria!", "Everything you'll need, right over here!"};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {20,90};
			};
			["Taximan Dave"] = {
				lines = {"Taximan Dave here to serve!", "I'll take you where you need to go, fast.", "Tired of walking? I'll carry you."};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {20,90};
			};
		};
				
		-- Fidelio
		["2546689567"] = {
			["Davey"] = {
				lines = {"ARRRRGGHHH!", "AHOY, GET ME SOME MORE MUFFINS!", "YAAARRRR!"};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {20,70};
			};
			["One-Eye Chuck"] = {
				lines = {"Yes yes, I sees everythin'.", "Shiver me timbers!", "Oy, whats this I sees over yonder?"};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {30,70};
			};
			
			["Evil Scientist"] = {
				lines = {"HAHAHAHAHAHA!", "HA HA HA HA HA!", "OOO HAHAHAHA!"};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {20,50};
			};
			
		};
		
		-- Scallop Shores
		["2471035818"] = {
			["Scout Foxtrot"] = {
				lines = {"Copy. Copy that? Over.", "Roger Delta. Delta Foxtrot.", "Copy, Rubees. Over."};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {20,70};
			};
			
			["Lieutenant Venessa"] = {
				lines = {"These bees...", "All this bee buzzing is getting to me.", "Got bees in my hair.", "They don't even look like bees."};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {20,70};
			};
			
			
		};
		
		-- Enchanted Forest
		["2260598172"] = {
			["Gnometta"] = {
				lines = {"eeeek!", "im so pretty!", "i'm prettier than gnoma!"};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {20,70};
			};
			
			["Gnomeo"] = {
				lines = {"im gnomeo!", "spiders are so scary!"};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {20,70};
			};
			
			
			
			["Gnoma"] = {
				lines = {"squeeaak!", "i'm prettier than gnometta!", "i love gnomeo!"};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {20,70};
			};
			
			
			
		};
		
		
		-- Warrior Stronghold
		["2470481225"] = {
			["Major Bicep"] = {
				lines = {"HUP HUP! HUP HUP!", "I'VE SEEN BABY MUSHROOMS TOUGHER THAN YOU LOT!", "I TRIPLE HOG DARE ONE OF YOU TO STOP!",  "THAT WARRIOR BOD DOESN'T COME EASY!", "YOU ALL LOOK LIKE YETI DINNER TO ME!", "IS THAT SLOUCHING I SEE?", "AWWWW, ARE YOU GUYS GETTING TIRED?", "THIS HURTS ME MORE THAN IT HURTS YOU!", "FIRST ONE TO STOP CLEANS THE LATRINES!", "ONLY 1000 MORE TO GO!"};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {10,20};
			};
			
			["Warrior Guard Steve"] = {
				lines = {"I hate my job."};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {40,120};
			};
			
			["Knight of the Night"] = {
				lines = {"I am vengeance, I am the night, I am the Knight of the Night.", "Evil lurks in the darkness of night, and I am the night light.","Every castle needs a hero. Am I this castle's hero? Definitely."};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {30,100};
			};
			
		};
		
		-- Farmlands
		["2180867434"] = {
			["Farmer Sam"] = {
				lines = {"Wicked scarecrows stealin' all the hay.", "I got my horse in the front, hogs in the back.", "I'm just a simple farmer, don't want no trouble.",  "Oops, looks like some of my hogs got loose."};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {20,60};
			};
			
			["Albert Figgleglasses"] = {
				lines = {"hehe i'm so silly!", "i like beans!", "it's so pretty here!",  "i love vesteria!"};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {20,60};
			};
			
			["Long John Silver"] = {
				lines = {"Simple livin' out here.", "I don't get those fancy pants city slickers.",  "We're far out from the city here, boy aren't we."};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {20,60};
			};
			
			
			
		};
		
		
		
		-- Nilgarf Sewers
		["2878620739"] = {
			["Begger"] = {
				lines = {"Spare some change? Spare some change!", "GIVE ME MONEY!!! Please?", "Sharing is caring!",  "Hey, just a Mushcoin?"};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {15,35};
			};
			
			["The Ratking"] = {
				lines = {"I'M THE FREAKING RATKING!", "BOW TO ME MORTALS!", "MMMM MMM MMM! BOY DO I LOVE RATTY!",  "KING OF THE SEWERS! KING OF THE SEWERS! I'M THE KING OF THE SEWERS!", "BURRRRRPP"};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {30,60};
			};	
		};
		
		-- Redwood Pass
		["2376890690"] = {
			["Captain Bronzeheart"] = {
				lines = {"They didn't send me enough recruits... these won't last long.", "I love catapults.", "Supplies are running low...",  "Redwood Pass. So beautiful. So deadly.", "Wish I were back at the stronghold right now..."};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {30,90};
			};
		};
		
		
		
		
		-- Nilgarf
		["2119298605"] = {
			["Granny Shumps"] = {
				lines = {"Back in my day...", "All these darn adventurers trampling my lawn...",  "Hmmmpphh...", "These adventurers have no manners...",  "The lengths I go to keep this place orderly... sigh..."};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {10,20};
			};
			
			["Bankteller Craig"] = {
				lines = {"Keep your items safe at Nilgarf Bank!", "You can't buy success, but you sure can buy security!","Service that leaves a smile on your face!","Keeping your stuff safe since... forever!"};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {20,40};
			};
			
			["Bankteller Steve"] = {
				lines = {"We appreciate beta and alpha players equally!",  "Trust me, you can trust Nilgarf Bank!","Can't carry a Mushroom Spore more? Put your belongings in Nilgarf Bank!","Carrying things is so last year, come find out why!"};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {20,40};
			};
			
			["Bankteller Joe"] = {
				lines = {"Service that leaves a smile on your face!", "Can't carry a Mushroom Spore more? Put your belongings in Nilgarf Bank!", "Keeping your stuff safe since... forever!","Nilgarf Bank. The secure way.","\"100% customer satisfaction guaranteed!\""};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {20,40};
			};
			
			["Carpenter Liam"] = {
				lines = {"Dee dum dee dum", "Doo dum dee doo dum dee"};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {5,10};
			};
			
			["Carpenter Scott"] = {
				lines = {"Gotta lotta work to do...", "Hard day at the job..." , "Oh jeez am I busy at work..."};
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {20,70};
			};
				
			["Leif"] = {
				lines = {"Oh boy do I love me some fishin'","Just me and my fishin' is all I need.";
				offset = Vector3.new(0,.5,0);
				distanceMulti = 1;
				waitRange = {20,80};
			};
		}
	}
}
			
network:create("requestNPCChatInfo","RemoteFunction", "OnServerInvoke", function()
	local tabToSend = {}
	if mapSpecificChat[tostring(utilities.originPlaceId(game.PlaceId))] then
		local mapSpec = mapSpecificChat[tostring(utilities.originPlaceId(game.PlaceId))] 
		for name, tab in pairs(mapSpec) do
			table.insert(tabToSend, {name, tab.offset, tab.distanceMulti})
		end
		
	end
	return tabToSend
	
end)


-- set up server 
if mapSpecificChat[tostring(utilities.originPlaceId(game.PlaceId))] then
	local mapSpec = mapSpecificChat[tostring(utilities.originPlaceId(game.PlaceId))] 
	if mapSpec then
		for name, tab in pairs(mapSpec) do
			
			
			spawn(function()
				
				local minWait = 10
				local maxWait = 20
				if tab.waitRange then
					if typeof(tab.waitRange) == "table" then
						minWait = tab.waitRange[1]
						maxWait = tab.waitRange[2]
					elseif typeof(tab.waitRange) == "number" then
						minWait = tab.waitRange
						maxWait = tab.waitRange
					end
				end
				
				local chatPool = tab.lines
				local lastChat = chatPool[1]
				local chosenChat = lastChat
				while wait() do
					wait(math.random(minWait, maxWait))
					while chosenChat == lastChat and #chatPool > 1 do
						--wait()
						chosenChat = chatPool[math.random(#chatPool)]
					end
					network:fireAllClients("syncedNPCChat", name, chosenChat)
					lastChat = chosenChat
				end
			end)
		end
	end
end

network:create("syncedNPCChatByModel", "RemoteEvent")