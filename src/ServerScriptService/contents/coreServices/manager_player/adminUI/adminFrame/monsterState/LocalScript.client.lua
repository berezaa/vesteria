local player = game.Players.LocalPlayer
local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 		= modules.load("network")
	local placeSetup 	= modules.load("placeSetup")
local camera = workspace.CurrentCamera
	
local monsterManifestCollectionFolder 	= placeSetup.awaitPlaceFolder("monsterManifestCollection")
local monsterRenderCollectionFolder 	= placeSetup.awaitPlaceFolder("monsterRenderCollection")
local spawnRegionCollectionsFolder 		= placeSetup.awaitPlaceFolder("spawnRegionCollections")

local monsterStateFrame = script.Parent
local currMonster

local function updateMonsterStateDataUI(monsterStateData)

	monsterStateFrame.changeState.Visible = true
	
	monsterStateFrame.info.viewing.value.Text 		= monsterStateData["name"] or "nil"
	monsterStateFrame.info.lastUpdated.value.Text 	= monsterStateData["last-updated"] or "nil"
	monsterStateFrame.info.targetPlayer.value.Text 	= monsterStateData["target-player"] or "nil"
	monsterStateFrame.info.state.value.Text 		= monsterStateData["current-state"] or "nil"
	monsterStateFrame.info.previousState.value.Text = monsterStateData["previous-state"] or "nil"
	--monsterStateFrame.info.closestPlayer.value.Text = monsterStateData["closest-player"]
end

local fakeMouse = {} do
	local userInputService = game:GetService("UserInputService")
	
	function fakeMouse:getMouseTarget(ignoreList)
		local mouseLocation = userInputService:GetMouseLocation()
		
		if mouseLocation then
			local ray_unit = camera:ScreenPointToRay(mouseLocation.X, mouseLocation.Y)
			local ray 		= Ray.new(ray_unit.Origin, ray_unit.Direction * 30)
			local hitPart, hitPosition = workspace:FindPartOnRayWithWhitelist(ray, ignoreList or {monsterManifestCollectionFolder})
			
			return hitPart, hitPosition
		end
	end
	
	--[[
	return {
		["previous-state"] 	= monster.stateMachine.previousState;
		["current-state"] 	= monster.stateMachine.currentState;
		["name"] 			= monster.name;
		["target-player"] 	= monster.targetPlayer;
		["closest-player"] 	= monster.closestPlayer;
		["last-updated"] 	= math.floor((tick() - monster.__LAST_UPDATE)*1000*100)/100;
	}
	--]]
	
	local function onInputBegan(inputObject)
		if inputObject.UserInputType == Enum.UserInputType.MouseButton1 and userInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
			local mouseTarget = fakeMouse:getMouseTarget()

			
			if mouseTarget and mouseTarget:IsDescendantOf(monsterRenderCollectionFolder) then
				if mouseTarget.Parent:FindFirstChild("clientHitboxToServerHitboxReference") then
					mouseTarget = mouseTarget.Parent.clientHitboxToServerHitboxReference.Value

				end
			end
			
			if mouseTarget and (mouseTarget:IsDescendantOf(monsterManifestCollectionFolder)) then
				local isDeveloper = player:FindFirstChild("developer")
				
				if isDeveloper then
					local registered, monsterStateData = network:invokeServer("registerToMonsterState", mouseTarget)
					
					if registered then
						currMonster = mouseTarget
						updateMonsterStateDataUI(monsterStateData)
					end
				end
			end
		end
	end
	
	userInputService.InputBegan:connect(onInputBegan)
end

local function main()
	network:connect("monsterStateChanged", "OnClientEvent", updateMonsterStateDataUI)
end

main()