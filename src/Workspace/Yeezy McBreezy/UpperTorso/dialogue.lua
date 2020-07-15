local function classFunc(class)
	return function(util)
		local success, reason = util.network:invokeServer("utilNpcClassChange", class)
		if success then
			return {{text = "*Magical girl anime transformation scene.*", font = Enum.Font.SourceSansBold}, {text = "Congratulations, you're now a "..class.."!"}}
		else
			return {{text = "I couldn't do it. You probably already have a class. Reset first."}}
		end
	end
end

local dialogue = {
	id = "startTalkingTo",
	dialogue = {{text = "Henlo my guys."}},
	options = {
		{
			response = "Reset",
			dialogue = function(util)
				local success, reason = util.network:invokeServer("playerRequest_rebirthPlayer")
				if success then
					return {{text = "Yeetus McBeetus your level deletus!"}}
				else
					if reason == "notEnoughSpace" then
						return {{text = "Can't fit your stuff, dummy"}}
					else
						return {{text = "The code broke, it's probably berezaa's fault"}}
					end
				end
			end,
		},
		
		{
			response = "Level 30",
			dialogue = function(util)
				local level = util.network:invoke("getCacheValueByNameTag", "level") or 0
				if level ~= 10 then
					return {{text = "Be level 10 first."}}
				end
				
				local success, reason = util.network:invokeServer("utilNpcLevelBoost", 30)
				if success then
					return {{text = "You're level 30 now."}}
				else
					return {{text = "Something went wrong. Blame Polymorphic."}}
				end
			end
		},
		
		{
			response = "Level 50",
			dialogue = function(util)
				local level = util.network:invoke("getCacheValueByNameTag", "level") or 0
				if level ~= 30 then
					return {{text = "Be level 30 first."}}
				end
				
				local success, reason = util.network:invokeServer("utilNpcLevelBoost", 50)
				if success then
					return {{text = "You're level 50 now."}}
				else
					return {{text = "Something went wrong. Prisman's fault, probably."}}
				end
			end
		},
		
		{response = "Hunter", dialogue = classFunc("Hunter"), responseButtonColor = Color3.fromRGB(75, 151, 75)},
		{response = "Warrior", dialogue = classFunc("Warrior"), responseButtonColor = Color3.fromRGB(255, 89, 89)},
		{response = "Mage", dialogue = classFunc("Mage"), responseButtonColor = Color3.fromRGB(82, 124, 174)},
		
		{response = "Assassin", dialogue = classFunc("Assassin"), responseButtonColor = Color3.fromRGB(75, 151, 75)},
		{response = "Ranger", dialogue = classFunc("Ranger"), responseButtonColor = Color3.fromRGB(75, 151, 75)},
		{response = "Trickster", dialogue = classFunc("Trickster"), responseButtonColor = Color3.fromRGB(75, 151, 75)},
		
		{response = "Knight", dialogue = classFunc("Knight"), responseButtonColor = Color3.fromRGB(255, 89, 89)},
		{response = "Berserker", dialogue = classFunc("Berserker"), responseButtonColor = Color3.fromRGB(255, 89, 89)},
		{response = "Paladin", dialogue = classFunc("Paladin"), responseButtonColor = Color3.fromRGB(255, 89, 89)},
		
		{response = "Sorcerer", dialogue = classFunc("Sorcerer"), responseButtonColor = Color3.fromRGB(82, 124, 174)},
		{response = "Warlock", dialogue = classFunc("Warlock"), responseButtonColor = Color3.fromRGB(82, 124, 174)},
		{response = "Cleric", dialogue = classFunc("Cleric"), responseButtonColor = Color3.fromRGB(82, 124, 174)},
	}
}

return dialogue