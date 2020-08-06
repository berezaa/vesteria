local module = {}

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network = modules.load("network")

local currentPlayerSeatPart = nil
local player 				= game.Players.LocalPlayer

local function seatPlayer(seatPart)
	if not player or not player.Character or not player.Character.PrimaryPart then return false end
	
	-- sit the player in the proper position
	player.Character.PrimaryPart.CFrame 	= script.Parent.CFrame + Vector3.new(0, 0.5, 0)
	player.Character.PrimaryPart.Anchored 	= true
	
	-- change the state to isSitting, isSitting is authoritative 
	network:invoke("setCharacterMovementState", "isSitting", true, script.Parent)
	
	currentPlayerSeatPart = seatPart
	
	-- success!
	return true
end

local function unseatPlayer()
	
end

local function isPlayerSitting()
	
end

local function getPlayerSeat()
	
end

local function main()
	network:create("seatPlayer", "BindableFunction", "OnInvoke", seatPlayer)
	network:create("unseatPlayer", "BindableFunction", "OnInvoke", unseatPlayer)
	network:create("getPlayerSeat", "BindableFunction", "OnInvoke", getPlayerSeat)
end

return module