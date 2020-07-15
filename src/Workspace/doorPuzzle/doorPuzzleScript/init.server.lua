local players = game:GetService("Players")
local collectionService = game:GetService("CollectionService")

local client = script.doorClientScript

local puzzle = script.Parent
local remotes = puzzle.remotes

-- set up the state which holds information about doors and levers
local state do
	state = {}
	local function getObjectState(object)
		if object:FindFirstChild("initialState") then
			return object.initialState.Value
		else
			return false
		end
	end
	
	state.doors = {}
	for _, door in pairs(puzzle.doors:GetChildren()) do
		state.doors[door] = getObjectState(door)
	end
	
	state.levers = {}
	for _, lever in pairs(puzzle.levers:GetChildren()) do
		state.levers[lever] = getObjectState(lever)
	end
end

-- set up the client and data distribution
local function onPlayerAdded(player)
	client:Clone().Parent = player.PlayerGui
	
	for door, value in pairs(state.doors) do
		remotes.stateUpdated:FireClient(player, door, "door", value, "initialized")
	end
	for lever, value in pairs(state.levers) do
		remotes.stateUpdated:FireClient(player, lever, "lever", value, "initialized")
	end
end
players.PlayerAdded:connect(onPlayerAdded)
for _, player in pairs(players:GetPlayers()) do
	onPlayerAdded(player)
end

-- when a player toggles the lever, we ought to do something about it
local toggleLast = 0
local toggleTime = 3

local function setLeversAvailable(available)
	for lever, _ in pairs(state.levers) do
		local interactPart = lever.interactPart
		if available then
			collectionService:AddTag(interactPart, "interact")
		else
			collectionService:RemoveTag(interactPart, "interact")
		end
	end
end

local function onLeverToggled(player, lever)
	local since = tick() - toggleLast
	if since <= toggleTime then return end
	
	-- sanity check distance
	local char = player.Character
	if not char then return end
	local manifest = char.PrimaryPart
	if not manifest then return end
	local distance = (lever.PrimaryPart.Position - manifest.Position).Magnitude
	if distance > 6 then return end
	
	-- cool down
	toggleLast = tick()
	
	-- don't allow activation during cooldown period
	setLeversAvailable(false)
	delay(toggleTime, function()
		setLeversAvailable(true)
	end)
	
	-- toggle the states and propogate
	state.levers[lever] = not state.levers[lever]
	remotes.stateUpdated:FireAllClients(lever, "lever", state.levers[lever], "changed")
	
	for _, doorRef in pairs(lever.doors:GetChildren()) do
		local door = doorRef.Value
		if state.doors[door] ~= nil then
			state.doors[door] = not state.doors[door]
			remotes.stateUpdated:FireAllClients(door, "door", state.doors[door], "changed")
		end
	end
end
remotes.leverToggled.OnServerEvent:Connect(onLeverToggled)
