-- ber's attempt to tackle interaction in one night
-- making stuff up as i go instead of planning in advance

local module = {}

local interactions = {}
module.interactions = interactions

local player = game:GetService("Players").LocalPlayer
local gui = player.PlayerGui.gameUI.interactFrame

local function isWorldPositionInFrame(worldPos)
	local screenPos = workspace.CurrentCamera:WorldToScreenPoint(worldPos)
	local max = workspace.CurrentCamera.ViewportSize
	return screenPos.Z > 0 and screenPos.X > 0 and screenPos.Y > 0 and screenPos.X <= max.X and screenPos.Y <= max.Y
end

function module.interact()
end

local isPlayerTarget 

local playingNPCAnimation = false

-- i can already feel damien's tears
local camCf = CFrame.new(1.63647461, 0.723526001, -8.12826347, -0.796550155, -0.0972865224, 0.596693575, -0, 0.986967802, 0.160917893, -0.604572475, 0.128179163, -0.78616941)




-- for talking animations
local idlesAllowedToTalk = {
	["rbxassetid://2267538527"] = {useBody = true};
	["rbxassetid://2345613400"] = {useBody = false}; -- arms crossed
	["rbxassetid://2861532980"] = {useBody = true};
	["rbxassetid://3539593106"] = {useBody = true};
	["rbxassetid://3539592561"] = {useBody = true};
	["rbxassetid://3539591914"] = {useBody = true};
	
	["rbxassetid://3244862244"] = {useBody = false}; -- warrior sword pose
	["rbxassetid://2510524077"] = {useBody = false}; -- sweeping
	["rbxassetid://3165415763"] = {useBody = false}; -- fishing
}
--    or target.Parent:FindFirstChild("idle").AnimationId == "rbxassetid://3539591914" or target.Parent:FindFirstChild("idle").AnimationId == "rbxassetid://3244862244" or target.Parent:FindFirstChild("idle").AnimationId == "rbxassetid://3244862244")) 

function module.init(Modules)
	
	local targetCf
	local targetCfTime
	
	local network = Modules.network
	
	local collectionService = game:GetService("CollectionService")	
	
	for i,interaction in pairs(collectionService:GetTagged("interact")) do
		table.insert(interactions,interaction)
	end
	
	collectionService:GetInstanceAddedSignal("interact"):connect(function(interaction)
		table.insert(interactions,interaction)
	end)
	
	collectionService:GetInstanceRemovedSignal("interact"):connect(function(interaction)
		for i,interact in pairs(interactions) do
			if interact == interaction then
				table.remove(interactions,i)
			end
		end
	end)
	
	module.currentInteraction = nil	
	
	local interactPrompt = gui.interact	
	
	function module.stopInteract()
		interactPrompt.Parent = gui
		
		local target = module.currentInteraction
		if target and target.Parent then
			if game.CollectionService:HasTag(target.Parent, "treasureChest") then
				-- nothing lol xD
			elseif target.Parent:FindFirstChild("clientHitboxToServerHitboxReference") then
				Modules.playerInteract.hide()
			elseif target:FindFirstChild("interactScript") then
				local interactScript = require(target.interactScript)
				interactScript.close(Modules)
			elseif game.CollectionService:HasTag(target, "teleportPart") then
				
				local partyData = network:invoke("getCurrentPartyInfo")
				if partyData then
					if partyData.isClientPartyLeader then
						-- teleport invoke server cancel
						network:invokeServer("playerRequest_cancelGroupTeleport")
					end
				end	

						
			elseif target.Parent.Name == "Shopkeeper" then
				Modules.shop.close(true)
				network:invoke("setCharacterArrested", false)
			elseif target:FindFirstChild("dialogue") then
				Modules.dialogue.endDialogue(target.dialogue)
				Modules.shop.close(true)
			end
		end
			
		module.currentInteraction = nil
		network:invoke("lockCameraPosition",false)
		network:invoke("setStopRenderingPlayers", false)
	end		
			
	network:create("stopInteraction", "BindableFunction", "OnInvoke", module.stopInteract)		
	
	local lastNearest
	
	local function step()
		local character = game.Players.LocalPlayer.Character
		if character and character.PrimaryPart then
			local nearest 
			local nearDist = 7
			
			
			local prompt = ""
			
			if module.currentInteraction and module.currentInteraction:IsA("BasePart") then
				local dist = (character.PrimaryPart.Position - module.currentInteraction.Position).magnitude
			
				if game.CollectionService:HasTag(module.currentInteraction, "teleportPart") then
					nearDist = 20
				end	
				
				if module.currentInteraction:FindFirstChild("range") then
					nearDist = module.currentInteraction.range.Value
				end
	
				if dist <= nearDist + 1.5 then	
					gui.Adornee = module.currentInteraction
					gui.Enabled = true
					prompt = "Leave"
					
					if module.currentInteraction:FindFirstChild("interactScript") then
						local interactScript = require(module.currentInteraction.interactScript)
						prompt = interactScript.leavePrompt or prompt
						
					elseif module.currentInteraction.Parent and module.currentInteraction.Parent:FindFirstChild("clientHitboxToServerHitboxReference") then
						prompt = "Cancel"
						-- 
						
					elseif collectionService:HasTag(module.currentInteraction, "seat") then
						prompt = "Get up"
						--
					
					end
					
					Modules.interactShell.show(interactPrompt)
					gui.Enabled = false						
				else
					module.stopInteract()
					gui.Adornee = nil
					gui.Enabled = false
				end
			else 
				local nearestDist = 999	
				local nearestPriority = -1
				for i, interaction in pairs(interactions) do
					if interaction:IsA("BasePart") and interaction:IsDescendantOf(workspace) then
						local priority = interaction:FindFirstChild("priority") and interaction.priority.Value or 1
						-- give players lower priority
						if interaction.Parent:FindFirstChild("clientHitboxToServerHitboxReference") then
							priority = 0
						end
						local dist = (character.PrimaryPart.Position - interaction.Position).magnitude
						
						if priority > nearestPriority then
							local range = interaction:FindFirstChild("range") and interaction.range.Value or 8
							if dist <= range then
								nearest = interaction
								nearestDist = dist
								nearestPriority = priority
							end
						end
						
						if priority >= nearestPriority and dist < nearestDist and isWorldPositionInFrame(interaction.Position) then
							nearest = interaction
							nearestDist = dist
						end
					end
				end
			
				
				
				if nearest then
					
					local range = nearest:FindFirstChild("range") and nearest.range.Value or 8
					
					if (nearestDist <= range or game.CollectionService:HasTag(nearest, "teleportPart") ) then
					
						gui.Adornee = nearest
						
						prompt = "Interact"
						if game.CollectionService:HasTag(nearest.Parent, "treasureChest") then
							prompt = "Open"
						elseif nearest:FindFirstChild("interactScript") then
							local interactScript = require(nearest.interactScript)
							if interactScript.interactPrompt and type(interactScript.interactPrompt) == "string" then
								prompt = interactScript.interactPrompt
								prompt = prompt:sub(1,1):upper() .. prompt:sub(2):lower()
							end
							--[[
						elseif nearest.Parent and nearest.Parent:FindFirstChild("clientHitboxToServerHitboxReference") then
							
							local referenceValue = nearest.Parent:FindFirstChild("clientHitboxToServerHitboxReference")
							
							if referenceValue.Value and referenceValue.Value.Parent then
								local player = game.Players:GetPlayerFromCharacter(referenceValue.Value.Parent)
								
								if not player and referenceValue.Value:FindFirstChild("mirrorValue") and referenceValue.Value.mirrorValue.Value and referenceValue.Value.mirrorValue.Value.Parent then
									player = game.Players:GetPlayerFromCharacter(referenceValue.Value.mirrorValue.Value.Parent)
								end
								
								if player then
									Modules.playerInteract.show(player)
									isPlayerTarget = true
									prompt = nil
								end
							end
							]]
						elseif game.CollectionService:HasTag(nearest, "teleportPart") then
							prompt = "Travel"
						elseif nearest.Parent.Name == "Shopkeeper" then
							prompt = "Shop"
						elseif nearest:FindFirstChild("PromptOverride") then
							prompt = nearest:FindFirstChild("PromptOverride").Value
						elseif nearest:FindFirstChild("dialogue") then
							if nearest:FindFirstChild("OverridePrompt") then
								prompt = nearest:FindFirstChild("OverridePrompt").Value
							else
								prompt = "Talk"
							end
							
						elseif collectionService:HasTag(nearest, "seat") then
							prompt = "Sit"
						end
						
						if prompt then
							-- waving animation
							if nearest ~= lastNearest then
								local target = nearest
								if target.Parent and target.Parent:FindFirstChild("AnimationController") and target.Parent:FindFirstChild("greeting") then
									local track = target.Parent.AnimationController:LoadAnimation(target.Parent.greeting)
									if track  then --and target.Parent:FindFirstChild("beingGreeted") == nil
										local tag = Instance.new("BoolValue")
										tag.Name = "beingGreeted"
										tag.Parent = target.Parent
										track.Looped = false
										track.Priority = Enum.AnimationPriority.Action
										track:Play()
										local stopConnection
										stopConnection = track.Stopped:connect(function()
											stopConnection:disconnect()
											if tag then
												tag:Destroy()
											end
										end)
									end
								end									
							end								
							
							lastNearest = nearest
							gui.Enabled = true
							
						else
							gui.Enabled = false
							lastNearest = nil
						end
						
						if isPlayerTarget and not (nearest.Parent and nearest.Parent:FindFirstChild("clientHitboxToServerHitboxReference")) then
							isPlayerTarget = false
							Modules.playerInteract.hide()
							lastNearest = nil
						end
					else
						gui.Enabled = false
						if isPlayerTarget then
							Modules.playerInteract.hide()
						end
						lastNearest = nil							
					end
				else
					gui.Enabled = false
					if isPlayerTarget then
						Modules.playerInteract.hide()
					end
					lastNearest = nil
					
					
				end				
			end		
					
			if prompt then
				interactPrompt.value.Text = prompt
				interactPrompt.valueMobile.Text = prompt
				
				
				local contents = game.TextService:GetTextSize(interactPrompt.value.Text, interactPrompt.value.TextSize, interactPrompt.value.Font, Vector2.new())
				
				interactPrompt.description.Size = UDim2.new(0, contents.X + 56, 0, 36)			
				
				local contentsMobile = game.TextService:GetTextSize(interactPrompt.valueMobile.Text, interactPrompt.valueMobile.TextSize, interactPrompt.valueMobile.Font, Vector2.new())
				
				interactPrompt.button.Size = UDim2.new(0, contents.X + 30, 0, 38)	
				
			end

		end
	end	

	game:GetService("RunService").Heartbeat:connect(step)
	--game:GetService("RunService"):BindToRenderStep("interactionStep", Enum.RenderPriority.Camera.Value - 1, step)
	
	
	function module.interact()
		local target = gui.Adornee
		
		if module.currentInteraction == target then
			module.stopInteract()
		else
			module.currentInteraction = target
			if (gui.Enabled or isPlayerTarget) and target then
				if target:FindFirstChild("helloSound") then
					Modules.utilities.playSound(target.helloSound.Value, target)
				end
				local track
				local controller = target.Parent:FindFirstChild("AnimationController")
				if target.Parent and controller and target.Parent:FindFirstChild("talk") then
					track = target.Parent.AnimationController:LoadAnimation(target.Parent.talk)
				elseif controller then
					track = target.Parent.AnimationController:LoadAnimation(script.defaulttalk)
				end
					
					if track  and target.Parent:FindFirstChild("idle") and idlesAllowedToTalk[target.Parent:FindFirstChild("idle").AnimationId]  then --and target.Parent:FindFirstChild("beingGreeted") == nil
						
						if not  idlesAllowedToTalk[target.Parent:FindFirstChild("idle").AnimationId].useBody then
							track = target.Parent.AnimationController:LoadAnimation(script.defaulttalk_noarm)
						end
						
						local fadeTime = .5
						
						local tag = Instance.new("BoolValue")
						tag.Name = "beingGreeted"
						tag.Parent = target.Parent
						track.Looped = false
						track.Priority = Enum.AnimationPriority.Action
						track:Play(fadeTime)
						
						spawn(function()
							wait(0.5)
							
							local tracks = controller:GetPlayingAnimationTracks()
							for i, existingTrack in pairs(tracks) do
								if existingTrack.Animation and existingTrack.Animation.Name == "greeting" then
									existingTrack:Stop()
								end
							end							
						end)
						
						game.Debris:AddItem(tag, track.Length/track.Speed)
					end
					
				
				local dialogueObject = target:FindFirstChild("dialogue")				

				if game.CollectionService:HasTag(target.Parent, "treasureChest") then
					module.stopInteract()
					network:invoke("openTreasureChest_client", target.Parent)
				elseif target:FindFirstChild("interactScript") then
					local interactScript = require(target.interactScript)
					-- going through all lengths to avoid damien's network module
					interactScript.init(Modules)
					if interactScript.instant then
						module.stopInteract()
					end
				elseif target.Parent and target.Parent:FindFirstChild("clientHitboxToServerHitboxReference") then
					
					local referenceValue = target.Parent:FindFirstChild("clientHitboxToServerHitboxReference")
					
					if referenceValue.Value and referenceValue.Value.Parent then
						local player = game.Players:GetPlayerFromCharacter(referenceValue.Value.Parent)
						
						if not player and referenceValue.Value:FindFirstChild("mirrorValue") and referenceValue.Value.mirrorValue.Value and referenceValue.Value.mirrorValue.Value.Parent then
							player = game.Players:GetPlayerFromCharacter(referenceValue.Value.mirrorValue.Value.Parent)
						end
						
						if player then
							Modules.playerInteract.activate(player)
							module.stopInteract()
						end
					end			
					
					
				elseif game.CollectionService:HasTag(target, "teleportPart") then
					
					
					local partyData = network:invoke("getCurrentPartyInfo")
					if partyData then
						if partyData.isClientPartyLeader then
							-- teleport invoke server
							network:invokeServer("playerRequest_startGroupTeleport", target)
						else
							Modules.notifications.alert({text = "Only the party leader can teleport the party!"; textColor = Color3.fromRGB(255,170,170)}, 2)
							module.stopInteract()
						end
					end
	
					
				elseif target.Parent and target.Parent.Name == "Shopkeeper" then
--					local cf = target.CFrame:ToWorldSpace(camCf)\


					Modules.shop.open(target)
						
					
				elseif dialogueObject then
					-- initiate dialogue
					Modules.dialogue.beginDialogue(target, require(dialogueObject))
				elseif collectionService:HasTag(target, "seat") then
					network:invoke("seatPlayer", target)
				end
			end			
		end		
		
	end
	
	interactPrompt.button.Activated:connect(module.interact)
	
end

return module
