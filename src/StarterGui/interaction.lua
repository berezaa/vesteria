-- ber's attempt to tackle interaction in one night
-- making stuff up as i go instead of planning in advance

local module = {}

local interactions = {}
module.interactions = interactions

local CollectionService = game:GetService("CollectionService")

local network
local tween
local shop
local dialogue
local playerInteract
local interactShell
local utilities
local notifications

local __modules

local player = game.Players.LocalPlayer
local gui = player.PlayerGui.gameUI.interactFrame
local interactPrompt = gui.interact

local function isWorldPositionInFrame(worldPos)
	local screenPos = workspace.CurrentCamera:WorldToScreenPoint(worldPos)
	local max = workspace.CurrentCamera.ViewportSize
	return screenPos.Z > 0 and screenPos.X > 0 and screenPos.Y > 0 and screenPos.X <= max.X and screenPos.Y <= max.Y
end

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


local effects = script.Parent.effects

local isPlayerTarget
function module.interact()
	local target = gui.Adornee

	if module.currentInteraction == target then
		module.stopInteract()
	else
		module.currentInteraction = target
		if (gui.Enabled or isPlayerTarget) and target then
			if target:FindFirstChild("helloSound") then
				utilities.playSound(target.helloSound.Value, target)
			end
			local track
			local controller = target.Parent:FindFirstChild("AnimationController")
			if target.Parent and controller and target.Parent:FindFirstChild("talk") then
				track = target.Parent.AnimationController:LoadAnimation(target.Parent.talk)
			elseif controller then
				track = target.Parent.AnimationController:LoadAnimation(effects.defaulttalk)
			end
				if track  and target.Parent:FindFirstChild("idle") and idlesAllowedToTalk[target.Parent:FindFirstChild("idle").AnimationId]  then --and target.Parent:FindFirstChild("beingGreeted") == nil
					if not  idlesAllowedToTalk[target.Parent:FindFirstChild("idle").AnimationId].useBody then
						track = target.Parent.AnimationController:LoadAnimation(effects.defaulttalk_noarm)
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
						for _, existingTrack in pairs(tracks) do
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
				interactScript.init(__modules)
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
						playerInteract.activate(player)
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
						notifications.alert({
							text = "Only the party leader can teleport the party!";
							textColor = Color3.fromRGB(255,170,170)
						}, 2)
						module.stopInteract()
					end
				end


			elseif target.Parent and target.Parent.Name == "Shopkeeper" then
				shop.open(target)

			elseif dialogueObject then
				-- initiate dialogue
				dialogue.beginDialogue(target, require(dialogueObject))
			elseif CollectionService:HasTag(target, "seat") then
				network:invoke("seatPlayer", target)
			end
		end
	end
end

function module.stopInteract()
	interactPrompt.Parent = gui

	local target = module.currentInteraction
	if target and target.Parent then
		if game.CollectionService:HasTag(target.Parent, "treasureChest") then
			-- nothing lol xD
		elseif target.Parent:FindFirstChild("clientHitboxToServerHitboxReference") then
			playerInteract.hide()
		elseif target:FindFirstChild("interactScript") then
			local interactScript = require(target.interactScript)
			interactScript.close(__modules)
		elseif game.CollectionService:HasTag(target, "teleportPart") then

			local partyData = network:invoke("getCurrentPartyInfo")
			if partyData then
				if partyData.isClientPartyLeader then
					-- teleport invoke server cancel
					network:invokeServer("playerRequest_cancelGroupTeleport")
				end
			end


		elseif target.Parent.Name == "Shopkeeper" then
			shop.close(true)
			network:invoke("setCharacterArrested", false)
		elseif target:FindFirstChild("dialogue") then
			dialogue.endDialogue(target.dialogue)
			shop.close(true)
		end
	end

	module.currentInteraction = nil
	network:invoke("lockCameraPosition",false)
	network:invoke("setStopRenderingPlayers", false)
end

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
				elseif CollectionService:HasTag(module.currentInteraction, "seat") then
					prompt = "Get up"
				end
				interactShell.show(interactPrompt)
				gui.Enabled = false
			else
				module.stopInteract()
				gui.Adornee = nil
				gui.Enabled = false
			end
		else
			local nearestDist = 999
			local nearestPriority = -1
			for _, interaction in pairs(interactions) do
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
					elseif CollectionService:HasTag(nearest, "seat") then
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
						-- I shouldn't have to do this, but something is inexplicably setting this to false
						interactPrompt.Visible = true
					else
						gui.Enabled = false
						lastNearest = nil
					end
					if isPlayerTarget and not (nearest.Parent and nearest.Parent:FindFirstChild("clientHitboxToServerHitboxReference")) then
						isPlayerTarget = false
						playerInteract.hide()
						lastNearest = nil
					end
				else
					gui.Enabled = false
					if isPlayerTarget then
						playerInteract.hide()
					end
					lastNearest = nil
				end
			else
				gui.Enabled = false
				if isPlayerTarget then
					playerInteract.hide()
				end
				lastNearest = nil
			end
		end
		if prompt then
			interactPrompt.value.Text = prompt
			local contents = game.TextService:GetTextSize(
				interactPrompt.value.Text,
				interactPrompt.value.TextSize,
				interactPrompt.value.Font,
				Vector2.new()
			)
			interactPrompt.button.Size = UDim2.new(0, contents.X + 56, 0, 36)
		end
	end
end

function module.init(Modules)
	-- work-around since Modules needs to be passed to interact modules in world
	-- wonder what the implications of doing _G.Modules would be?
	__modules = Modules

	network = Modules.network
	tween = Modules.tween
	network = Modules.network
	tween = Modules.tween
	shop = Modules.shop
	dialogue = Modules.dialogue
	playerInteract = Modules.playerInteract
	interactShell = Modules.interactShell
	utilities = Modules.utilities
	notifications = Modules.notifications

	for _, interaction in pairs(CollectionService:GetTagged("interact")) do
		table.insert(interactions,interaction)
	end

	CollectionService:GetInstanceAddedSignal("interact"):connect(function(interaction)
		table.insert(interactions,interaction)
	end)

	CollectionService:GetInstanceRemovedSignal("interact"):connect(function(interaction)
		for i,interact in pairs(interactions) do
			if interact == interaction then
				table.remove(interactions,i)
			end
		end
	end)

	module.currentInteraction = nil

	network:create("stopInteraction", "BindableFunction", "OnInvoke", module.stopInteract)

	game:GetService("RunService").Heartbeat:connect(step)

	interactPrompt.button.Activated:connect(function()
		tween(interactPrompt.button, {"ImageColor3"}, {Color3.fromRGB(223, 223, 223)}, 0.5)
		module.interact()
	end)
	interactPrompt.button.MouseEnter:connect(function()
		tween(interactPrompt.button, {"ImageColor3"}, {Color3.fromRGB(111, 236, 255)}, 0.5)
	end)
	interactPrompt.button.MouseLeave:connect(function()
		tween(interactPrompt.button, {"ImageColor3"}, {Color3.fromRGB(223, 223, 223)}, 0.5)
	end)

end

return module
