local module = {}
local lookup = {}
	lookup.color = {
		b = BrickColor.Blue().Color;
	}

	lookup.font = {
		sourceSansBold = Enum.Font.SourceSansBold;
	}

local localizationService = game:GetService("LocalizationService")

-- this module is client-only, shouldnt even be in replicated storage, but I cant move it right now
if game:GetService("RunService"):IsServer() then
	return module
end

-- this is a temp. translator with no yield, does not include web translations
local translator = localizationService:GetTranslatorForPlayer(game.Players.LocalPlayer)

-- fetch the web translations
spawn(function()
	local success, err
	local n = 0
	repeat
		if err then
			warn("Failed to access cloud translations:", err)
			wait(n * 3)
		end
		success, err = pcall(function()
			translator = localizationService:GetTranslatorForPlayerAsync(game.Players.LocalPlayer)
		end)
		n = n + 1
	until success
end)

function module.translate(str, context)
	context = context or game
	return translator:Translate(context, str) or str
end

function module.convertToVesteriaDialogueTable(str)
	local dialogueTable = {}
	local currentSubDialogue = {}

	if str:sub(1, 1) ~= "[" then
		str = "[]" .. str
	end


	if str:sub(#str, #str) ~= "]" then
		str = str .. "[]"
	end

	for stylingData, text in string.gmatch(str, "([%w%;%:%=]-)%](.-)%[") do
		local block = {}
			block.text = text

		for styleType, style in string.gmatch(stylingData, "(%w+)%=(%w+)") do
			if (styleType == "font" or styleType == "f") then
				block.font = lookup.font[style] or Enum.Font.SourceSans
			elseif (styleType == "color" or styleType == "c") then
				block.textColor3 = lookup.color[style] or Color3.fromRGB(255, 255, 255)
			end
		end

		table.insert(dialogueTable, block)
	end

	return dialogueTable
end

return module