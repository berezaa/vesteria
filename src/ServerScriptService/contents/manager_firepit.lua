local module = {}

local CollectionService = game:GetService("CollectionService")

local network

local statusEffectsV3 = require(game.ServerStorage.statusEffectsV3)

local firepits = CollectionService:GetTagged("firepit")

local isPlayerNearFirepit = {}
local DISTANCE_TO_BE_CLOSE = 15

local buff_data = {
	icon = "rbxassetid://595268981";
	modifierData = {
		manaRegen 		= 2;
		healthRegen 	= 80;
	};

	DO_NOT_SAVE = true;
}

local function onPlayerRemoving(player)
	isPlayerNearFirepit[player] = nil
end

local function loop()
	while wait(1/2) do
		if #firepits > 0 then
			for _, player in pairs(game.Players:GetPlayers()) do
				if player.Character and player.Character.PrimaryPart then
					local isNearFirepit, distanceAway = false, DISTANCE_TO_BE_CLOSE

					for _, firepit in pairs(firepits) do
						local distFrom = (player.Character.PrimaryPart.Position - firepit.Position).magnitude

						if distFrom < DISTANCE_TO_BE_CLOSE and (not firepit:FindFirstChild("Fire") or firepit.Fire.Enabled) then
							isNearFirepit 	= true
							distanceAway 	= distFrom

							break
						end
					end

					if isNearFirepit ~= not not isPlayerNearFirepit[player] then
						if isNearFirepit then
							local wasApplied, statusEffectGUID = network:invoke("applyStatusEffectToEntityManifest", player.Character.PrimaryPart, "empower", buff_data, player.Character.PrimaryPart, "firepit", 0)

							if wasApplied then
								local untarget 	= Instance.new("BoolValue")
								untarget.Name 	= "isTargetImmune"
								untarget.Value 	= true
								untarget.Parent = player.Character.PrimaryPart

								isPlayerNearFirepit[player] = statusEffectGUID
							end
						else
							if player.Character.PrimaryPart:FindFirstChild("isTargetImmune") then
								player.Character.PrimaryPart.isTargetImmune:Destroy()
							end

							local wasRevoked = network:invoke("revokeStatusEffectByStatusEffectGUID", isPlayerNearFirepit[player])

							--if wasRevoked then
								isPlayerNearFirepit[player] = nil
							--end
						end
					elseif isNearFirepit and distanceAway < 3 then
						-- is touching firepit, add stacks of ablaze
						local statusEffect = statusEffectsV3.createStatusEffect(
							player.Character.PrimaryPart,
							nil,
							"ablaze",
							{
								damage 		= 10;
								duration 	= 10;
							}, "firepit-ablaze"
						)

						if statusEffect then
							statusEffect:start()
						end
					end
				end
			end
		end
	end
end

function module.init(Modules)

	network = Modules.network

	game.Players.PlayerRemoving:connect(onPlayerRemoving)

	spawn(loop)
end

return module
