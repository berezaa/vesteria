-- will move when deployed if necessary 
local class = {}
class.__index = class


function class.new(object)
	--print("Character Object:", object)
	local self = setmetatable({}, class)
	self.character = game.Players.LocalPlayer.Character
	self.state = ""
	self.animations = {}
	print(self.character:GetFullName())
	self.events = {
		["StateHandler"] = self.character.hitbox.state.Changed:Connect(function(value)
			--print("State: ", value)
			self.state = value
		end)
	}
	
	--[[for _,anim in pairs() do
		self.animations[anim] = self.character.Humanoid:LoadAnimation(anim)
	end]]
end



return class
