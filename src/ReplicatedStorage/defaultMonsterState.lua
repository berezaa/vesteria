local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local pathfinding 	= modules.load("pathfinding")
		local utilities		= modules.load("utilities")
		local detection		= modules.load("detection")
		local network		= modules.load("network")

local MONSTER_END_POSITION_ALPHA = 1

local rand = Random.new()

return {
	processDamageRequest = function(sourceId, baseDamage)
		return baseDamage, "physical", "direct"
	end;

	getClosestEntities = function(monster)
		local pool = utilities.getEntities()

		for i = #pool, 1, -1 do
			local v = pool[i]

			if v.Name == monster.monsterName or v == monster.manifest or v.health.Value <= 0 then
				table.remove(pool, i)
			end
		end

		return pool
	end;

	default = "idling",
	states 	= {
		["setup"] = {
			animationEquivalent = "idling";
			transitionLevel = 0;
			step 			= function(monster)
				if monster.moveGoal then
					monster.__directRoamGoal = monster.moveGoal
					monster.__directRoamOrigin = monster.manifest.Position
					monster.__blockConfidence = 0
					monster.__LAST_ROAM_TIME = tick()
					return "direct-roam"
				end
			end;
		};
		["sleeping"] = {
			animationEquivalent = "idling";
			timeBetweenUpdates 	= 5;
			transitionLevel 	= 1;
			step 				= function(monster, canSwitchState)
				if monster.closestEntity then
					return "idling"
				end
			end;
		}; ["idling"] = {
			lockTimeForLowerTransition 	= 3;
			transitionLevel 			= 2;
			step 						= function(monster, canSwitchState)

				monster.manifest.BodyVelocity.Velocity = Vector3.new()

				if monster.moveGoal then
					monster.__directRoamGoal = monster.moveGoal
					monster.__directRoamOrigin = monster.manifest.Position
					monster.__blockConfidence = 0
					monster.__LAST_ROAM_TIME = tick()
					return "direct-roam"
				end

				if monster.targetEntity then
					return "following"
				end

				if monster.closestEntity and monster.closestEntity.health.value >= 0 then
					local closestEntityDistance = utilities.magnitude(monster.closestEntity.Position - monster.manifest.Position)
					local aggressionLockRange = monster.aggressionLockRange or monster.aggressionRange

					if closestEntityDistance <= aggressionLockRange and monster:isTargetEntityInLineOfSight(aggressionLockRange, true) then
						monster.__providedDirectRoamTheta = nil
						monster:setTargetEntity(monster.closestEntity)

						return "following"
					else
						if canSwitchState or monster.__providedDirectRoamTheta then
							if (monster.__LAST_ROAM_TIME and tick() - monster.__LAST_ROAM_TIME < 5) and (monster.__providedDirectRoamTheta == nil) then
								return "idling"
							end

							local XZ = Vector3.new(1, 0, 1)

--							local targetPosition = monster:getRoamPositionInSpawnRegion()

							local theta = rand:NextInteger(1,360)

							if monster.__providedDirectRoamTheta then
								theta = monster.__providedDirectRoamTheta
								monster.__providedDirectRoamTheta = nil
							end

							local rad = math.rad(theta)

							local monsterPos = monster.manifest.Position * XZ

							local targetPosition = monsterPos + Vector3.new(math.cos(rad), 0, math.sin(rad)) * rand:NextInteger(10, monster.maxRoamDistance or 50)

							local direction = targetPosition - monsterPos

							local startPos = monster.manifest.Position + Vector3.new(0, monster.manifest.Size.Y / 2, 0)
							local finalDirection = direction - Vector3.new(0, monster.manifest.Size.Y / 2, 0)

							local rey = Ray.new(startPos, finalDirection)

							local hitPart, hitPosition = workspace:FindPartOnRayWithIgnoreList(rey,{monster.manifest,workspace.placeFolders:FindFirstChild("entityRenderCollection"),workspace.placeFolders:FindFirstChild("foilage")})

							local monsterSize = (monster.manifest.Size.X + monster.manifest.Size.Z) / 2

							local distance = (hitPosition - monster.manifest.Position).magnitude

							-- cap the distance
							--[[
							if distance > (monster.maxRoamDistance or 50) then
								hitPosition = startPos + finalDirection * 50
							end
							]]

							local canRoam = true

							local directRoamGoal = (hitPosition - direction * monsterSize/2) * XZ

							if distance >= monsterSize and canRoam then
								monster.__directRoamGoal = directRoamGoal
								monster.__directRoamOrigin = monsterPos
								monster.__directRoamTheta = theta
								monster.__blockConfidence = 0
								monster.__LAST_ROAM_TIME = tick()
								return "direct-roam"
							end

							monster.__LAST_ROAM_TIME = tick() - 4.5
							return
						end
					end
				else
					return "sleeping"
				end
			end;
		}; ["wait-roaming"] = {
			animationEquivalent = "idling";
			transitionLevel 	= 3;
			step 				= function(monster, canSwitchState)
				if not monster.__IS_WAITING_FOR_PATH_FINDING then
					if monster.isProcessingPath then
						return "roaming"
					else
						monster:setTargetEntity(nil, nil)
						return "idling"
					end
				end
				--ber edit: end wait-roaming state and cancel pathfind if its been longer than 5 seconds
				--i think getting stuck in the wait-roaming step is what leads monsters getting frozen
				if monster.__PATHFIND_QUEUE_TIME and tick() - monster.__PATHFIND_QUEUE_TIME > 5 then
					monster:resetPathfinding()

					return "idling"
				end
			end

		}; ["direct-roam"] = {
			animationEquivalent = "walking";
			transitionLevel 	= 3;
			step 				= function(monster, canSwitchState)

				if monster.moveGoal then
					monster.moveGoal = nil
					-- ignore block confidence and other checks for normal roaming
					monster.__strictMovement = true
				end

				if monster.targetEntity then
					return "following"
				end

				if monster.closestEntity and canSwitchState then
					local closestEntityDistance = utilities.magnitude(monster.closestEntity.Position - monster.manifest.Position)
					local aggressionLockRange = monster.aggressionLockRange or monster.aggressionRange


					if closestEntityDistance <= aggressionLockRange and monster:isTargetEntityInLineOfSight(aggressionLockRange, true) then

						monster:setTargetEntity(monster.closestEntity, monster.closestEntity)
						return "following"
					end
				end

				local start, goal = monster.__directRoamOrigin, monster.__directRoamGoal
				if start and goal then
					local XZ = Vector3.new(1, 0, 1)

					local goalDistance = utilities.magnitude((goal - start) * XZ)
					local distance = utilities.magnitude((monster.manifest.Position - start) * XZ)

					local moveDirection = (goal * XZ - start * XZ).unit

					monster.manifest.BodyVelocity.Velocity = moveDirection * monster.baseSpeed
					monster.manifest.BodyGyro.CFrame = CFrame.new(start * XZ, goal * XZ)

					-- arrived
					if distance >= goalDistance then
						monster.__strictMovement = false
						-- give a chance to keep going in a similar direction
						if monster.__directRoamTheta and rand:NextNumber() > 0.5 then
							monster.__providedDirectRoamTheta = monster.__directRoamTheta + rand:NextInteger(-35,35)
							return "idling"
						end
						monster.__providedDirectRoamTheta = nil
						monster.manifest.BodyVelocity.Velocity 	= Vector3.new()
						return "idling"
					end

					-- blocked
					local expectedVelocity = monster.manifest.BodyVelocity.Velocity
					local actualVelocity = monster.manifest.Velocity

					local ray1 = Ray.new(monster.manifest.Position, Vector3.new(0,-50,0))
					local ray2 = Ray.new(monster.manifest.Position + (moveDirection * monster.baseSpeed / 4), Vector3.new(0,-50,0))

					local _, hitpos1 = workspace:FindPartOnRayWithIgnoreList(ray1,{monster.manifest,workspace.placeFolders:FindFirstChild("entityRenderCollection"),workspace.placeFolders:FindFirstChild("foilage")})
					local _, hitpos2 = workspace:FindPartOnRayWithIgnoreList(ray2,{monster.manifest,workspace.placeFolders:FindFirstChild("entityRenderCollection"),workspace.placeFolders:FindFirstChild("foilage")})

					-- prevent running into things or falling off cliffs
					local yDisplacement = hitpos2.Y - hitpos1.Y
					if not monster.__strictMovement then
						if -yDisplacement >= math.max(monster.manifest.Size.Y, 6)then
							-- cliff!
							monster.manifest.BodyVelocity.Velocity 	= Vector3.new()
							return "idling"
						elseif tick() - monster.__LAST_ROAM_TIME >= 1 and actualVelocity.magnitude <= expectedVelocity.magnitude / 10 then
							-- blocked
							monster.manifest.BodyVelocity.Velocity 	= Vector3.new()
							return "idling"
						end
					end

					return
				end
				return "idling"
			end
		}; ["roaming"] = {
			animationEquivalent = "walking";
			transitionLevel = 3;
			step 			= function(monster, canSwitchState)
				if monster.closestEntity then
					if not monster.path then
						return "idling"
					end

					local closestEntityDistance = utilities.magnitude(monster.closestEntity.Position - monster.manifest.Position)

					local nodeAt = monster.path[monster.currentNode]
					local nodeTo = monster.path[monster.currentNode + 1]
					if nodeAt and nodeTo then
						if pathfinding.isPastNextPathfindingNodeNode(nodeAt.Position, monster.manifest.Position, nodeTo.Position) then
							-- arrived at node
							monster.currentNode 			= monster.currentNode + 1
							monster.__PATH_FIND_NODE_START 	= tick()

							local aggressionLockRange = monster.aggressionLockRange or monster.aggressionRange



							if closestEntityDistance <= aggressionLockRange and monster:isTargetEntityInLineOfSight(aggressionLockRange, true) then
								monster:resetPathfinding()
								monster:setTargetEntity(monster.closestEntity, monster.closestEntity)

								return "following"
							end
						else
							if tick() - monster.__PATH_FIND_NODE_START < 2 then
								-- move!
								local adjustNodeToPosition = Vector3.new(nodeTo.Position.X, monster.manifest.Position.Y, nodeTo.Position.Z)

								monster.manifest.BodyGyro.CFrame 		= CFrame.new(monster.manifest.Position, adjustNodeToPosition)
								monster.manifest.BodyVelocity.Velocity 	= (adjustNodeToPosition - monster.manifest.Position).unit * monster.baseSpeed
							else
								-- monster taking too long to move to node
								monster.manifest.BodyVelocity.Velocity = Vector3.new()
								monster:resetPathfinding()

								return "idling"
							end
						end
					elseif nodeAt and not nodeTo then
						-- reached the end

						monster.manifest.BodyVelocity.Velocity = Vector3.new()
						monster:resetPathfinding()

						return "idling"
					end
				end
			end;
		}; ["following"] = {
			animationEquivalent = "walking";
			transitionLevel = 4;
			step 			= function(monster, canSwitchState)
				if not monster.targetEntity then
					return "idling"
				end

				if monster.targetEntity.health.Value <= 0 then
					monster:setTargetEntity(nil, nil)
					return "idling"
				end

				local manifestProjectorPosition = monster.manifest.Position
				local targetEntity 				= monster.targetEntity
				local hrpPosition 				= targetEntity.Position

				-- normalize y value to prevent difficulties when it comes
				-- to the player and the monster being on different elevations

				local correctHRPPosition			= hrpPosition

				if monster.manifest.BodyVelocity.MaxForce.Y <= 0.1 then
					correctHRPPosition 			= Vector3.new(hrpPosition.X, manifestProjectorPosition.Y, hrpPosition.Z)
				end

				if monster.targetingYOffsetMulti then
					correctHRPPosition = correctHRPPosition + Vector3.new(0, monster.manifest.Size.Y * monster.targetingYOffsetMulti, 0)
				end

				-- account for velocity
				correctHRPPosition = correctHRPPosition + targetEntity.Velocity * 0.1


				local targetEntityDistance 			= utilities.magnitude(manifestProjectorPosition - correctHRPPosition)
				local moveDirection 				= (correctHRPPosition - manifestProjectorPosition).unit
				local positionJustInsideAttackRange = correctHRPPosition - moveDirection * (monster.attackRange)

				--monster.DEBUG_TARGET_PART.CFrame = CFrame.new(positionJustInsideAttackRange)
				local movingSpeed = monster.followSpeed or monster.baseSpeed
				-- have monster move in direction of player
				-- but respect step to make this movement
				-- framerate independent
				-- CFrame.new(manifestProjectorPosition, positionJustInsideAttackRange) * CFrame.new(0, 0, -monster.baseSpeed * (step + (tick() - currTime)))
				if monster:isTargetEntityInLineOfSight(monster.targetEntitySetSource and 999, not monster.targetEntitySetSource) then
					-- player is still in line of sight of monster
					monster.manifest.BodyVelocity.Velocity 	= moveDirection * movingSpeed
					monster.manifest.BodyGyro.CFrame 		= CFrame.new(manifestProjectorPosition, Vector3.new(correctHRPPosition.X, manifestProjectorPosition.Y, correctHRPPosition.Z))   --CFrame.new(manifestProjectorPosition, correctHRPPosition)
					monster.__LAST_POSITION_SEEN 			= positionJustInsideAttackRange
					monster.__LAST_MOVE_DIRECTION 			= moveDirection * movingSpeed
				else
					if not monster.__LAST_POSITION_SEEN then
						-- player is not in line of sight, but is still within aggro range -- pathfind!

						-- ber edit: lose focus if the player is out of range
						monster:setTargetEntity(nil, nil)
						monster.manifest.BodyVelocity.Velocity 	= Vector3.new()
						return "idling"


					elseif monster.__LAST_POSITION_SEEN then
						local lowerLastPositionSeen = Vector3.new(monster.__LAST_POSITION_SEEN.X, manifestProjectorPosition.Y, monster.__LAST_POSITION_SEEN.Z)

						monster.manifest.BodyVelocity.Velocity = (lowerLastPositionSeen - manifestProjectorPosition).unit * movingSpeed

						local sightRange = monster.sightRange


						if targetEntityDistance <= sightRange then
							-- check if the monster is close 'enough' to the last position seen
							-- based on the position alpha
							if utilities.magnitude(manifestProjectorPosition - monster.__LAST_POSITION_SEEN) > MONSTER_END_POSITION_ALPHA then
								monster.__LAST_POSITION_SEEN = nil


								monster:setTargetEntity(nil)
								return "idling"
							end
						else
							if monster.targetEntitySetSource == nil then
								monster:setTargetEntity(nil)
								return "idling"
							end
						end
					else
						monster:setTargetEntity(nil)
						return "idling"
					end
				end

				local manifestProjection 		= detection.projection_Box(monster.manifest.CFrame, monster.manifest.Size, hrpPosition)
				local targetEntityProjection 	= detection.projection_Box(monster.targetEntity.CFrame, monster.targetEntity.Size, monster.manifest.Position)
				local targetEntityDistance 		= utilities.magnitude(manifestProjection - targetEntityProjection)

				if targetEntityDistance <= monster.attackRange then
					return "attack-ready"
				end
			end;
		}; ["attack-ready"] = {
			animationEquivalent = "idling";
			transitionLevel 	= 5;
			step 				= function(monster, canSwitchState)
				if monster.targetEntity == nil then
					return "idling"
				end

				if monster.targetEntity.health.Value <= 0 then
					monster:setTargetEntity(nil, nil)
					return "idling"
				end

				local manifestProjectorPosition = monster.manifest.Position
				local targetEntity 				= monster.targetEntity
				local hrpPosition 				= targetEntity.Position

				-- normalize y value to prevent difficulties when it comes
				-- to the player and the monster being on different elevations

				local correctHRPPosition = hrpPosition

				if monster.manifest.BodyVelocity.MaxForce.Y <= 0.1 then
					correctHRPPosition 			= Vector3.new(hrpPosition.X, manifestProjectorPosition.Y, hrpPosition.Z)
				end

				if monster.targetingYOffsetMulti then
					correctHRPPosition = correctHRPPosition + Vector3.new(0, monster.manifest.Size.Y * monster.targetingYOffsetMulti, 0)
				end

				local manifestProjection 		= detection.projection_Box(monster.manifest.CFrame, monster.manifest.Size, hrpPosition)
				local targetEntityProjection 	= detection.projection_Box(monster.targetEntity.CFrame, monster.targetEntity.Size, monster.manifest.Position)
				local targetEntityDistance 		= utilities.magnitude(manifestProjection - targetEntityProjection)

				if targetEntityDistance <= monster.attackRange then
					-- aggro'd and within attackRange
					local manifestProjectorPosition 		= monster.manifest.Position
--					monster.manifest.BodyGyro.CFrame 		= CFrame.new(manifestProjectorPosition, correctHRPPosition)

					if tick() - monster.__LAST_ATTACK_TIME >= monster.attackSpeed then
						monster.__LAST_ATTACK_TIME = tick()

						return "attacking"
					else
						monster.manifest.BodyVelocity.Velocity = Vector3.new()
					end
				else
					return "following"
				end
			end;
		}; ["attacking"] = {
			transitionLevel 		= 6;
			animationPriority 		= Enum.AnimationPriority.Action;
			doNotLoopAnimation 		= true;
			doNotStopAnimation 		= true;
			execute 				= function(player, targetAnimation, monsterData, clientMonsterContainer)
				if not game:GetService("RunService"):IsClient() then
					warn("attacking::execute can only be called on client")

					return
				elseif not monsterData.damageHitboxCollection then
					-- no damageHitboxCollection
				end

				-- prevent the player from taking damage twice from same animation
				local damageDebounce 	= false
				local characterHitbox 	= player.Character.PrimaryPart
				local serverHitbox 		= clientMonsterContainer.clientHitboxToServerHitboxReference.Value

				if clientMonsterContainer:FindFirstChild("entity") and clientMonsterContainer.entity.PrimaryPart:FindFirstChild("attacking") then
					local chance = 1
					if clientMonsterContainer:FindFirstChild("entity") and clientMonsterContainer.entity.PrimaryPart:FindFirstChild("attacking2") then
						chance = math.random(2)
						if chance == 2 then
							clientMonsterContainer.entity.PrimaryPart.attacking2:Play()
						end
					end
					if chance == 1 then
						clientMonsterContainer.entity.PrimaryPart.attacking:Play()
					end
				end

				-- slight delay
				local delayTime = targetAnimation.Length * (monsterData.animationDamageStart or 0.3)

				wait(delayTime)

				local endTime = targetAnimation.Length * (monsterData.animationDamageEnd or 0.7)

				local duration = endTime - delayTime

				local step = duration / 10

				for i = 0, duration, step do
					if targetAnimation.IsPlaying and not damageDebounce and clientMonsterContainer:FindFirstChild("entity") then
						for i, hitboxData in pairs(monsterData.damageHitboxCollection) do
							if clientMonsterContainer.entity:FindFirstChild(hitboxData.partName) and not damageDebounce then
								if hitboxData.castType == "sphere" then
									local spherecastOrigin = (clientMonsterContainer.entity[hitboxData.partName].CFrame * hitboxData.originOffset).p
									local boxProjection_HRP = detection.projection_Box(characterHitbox.CFrame, characterHitbox.Size, spherecastOrigin)
									if detection.spherecast_singleTarget(spherecastOrigin, hitboxData.radius, boxProjection_HRP) then
										damageDebounce = true

										network:fireServer("playerRequest_damageEntity", serverHitbox, boxProjection_HRP, "monster")
									end
								elseif hitboxData.castType == "box" then
									local boxcastOriginCF 	= clientMonsterContainer.entity[hitboxData.partName].CFrame * hitboxData.originOffset
									local boxProjection_HRP = detection.projection_Box(characterHitbox.CFrame, characterHitbox.Size, boxcastOriginCF.p)
									if detection.boxcast_singleTarget(boxcastOriginCF, clientMonsterContainer.entity[hitboxData.partName].Size * (hitboxData.hitboxSizeMultiplier or Vector3.new(1, 1, 1)), boxProjection_HRP) then
										damageDebounce = true

										network:fireServer("playerRequest_damageEntity", serverHitbox, boxProjection_HRP, "monster")
									end
								end
							end
						end

						wait(step)
					else
						break
					end
				end
			end;

			step 					= function(monster, canSwitchState)
				if monster.targetEntity == nil then
					return "idling"
				end

				local manifestProjectorPosition = monster.manifest.Position
				local targetEntity 				= monster.targetEntity
				local hrpPosition 				= targetEntity.Position

				-- normalize y value to prevent difficulties when it comes
				-- to the player and the monster being on different elevations

				local correctHRPPosition = hrpPosition

				if monster.manifest.BodyVelocity.MaxForce.Y <= 0.1 then
					correctHRPPosition = Vector3.new(hrpPosition.X, manifestProjectorPosition.Y, hrpPosition.Z)
				end

				if monster.targetingYOffsetMulti then
					correctHRPPosition = correctHRPPosition + Vector3.new(0, monster.manifest.Size.Y * monster.targetingYOffsetMulti, 0)
				end

				correctHRPPosition = correctHRPPosition + targetEntity.Velocity * 0.1

				local targetEntityDistance 		= utilities.magnitude(manifestProjectorPosition - correctHRPPosition)
				local moveDirection 				= (correctHRPPosition - manifestProjectorPosition).unit
				local positionJustInsideAttackRange = correctHRPPosition - moveDirection * (monster.attackRange)

				-- todo: this is awfully hacky, change this!
				-- monster.manifest.stance.Value = tostring(math.random())


					monster.manifest.BodyGyro.CFrame 		= CFrame.new(manifestProjectorPosition, correctHRPPosition)

				if utilities.magnitude(targetEntity.Velocity) > 3 then
					local moveDirection 					= (correctHRPPosition - manifestProjectorPosition).unit
					local positionJustInsideAttackRange 	= correctHRPPosition - moveDirection * (monster.attackRange)
					monster.manifest.BodyVelocity.Velocity 	= moveDirection * (monster.baseSpeed * 0.7)
				else
					monster.manifest.BodyVelocity.Velocity 	= Vector3.new()
				end

				local targetEntityPlayer = game.Players:GetPlayerFromCharacter(monster.targetEntity.Parent)

				if not targetEntityPlayer then

					delay(0.25, function()
						network:invoke("monsterDamageRequest_server",
							nil,
							monster.targetEntity,
							{
								damage 			= monster.damage;
								sourceType 		= "monster";
								sourceId 		= nil;
								damageCategory 	= "direct";
								damageType 		= "physical"
							}
						)
					end)
				end

				return "micro-sleeping"
			end;
		}; ["special-attacking"] = {
			animationEquivalent = "special-attack";
			transitionLevel = 7;
			step 			= function(monster, canSwitchState)
				monster.specialsUsed = monster.specialsUsed + 1

				if monster.__STATE_OVERRIDES["special-attacking"] then
					monster.__STATE_OVERRIDES["special-attacking"](monster)
				end

				return "special-recovering";
			end;
		}; ["micro-sleeping"] = {
			animationEquivalent 		= "idling";
			transitionLevel 			= 8;
			lockTimeForLowerTransition 	= 0.2;
			step 						= function(monster, canSwitchState)
				return "attack-ready"
			end;
		};["special-recovering"] = {
			animationEquivalent 		= "idling";
			transitionLevel 			= 9;
			lockTimeForLowerTransition 	= 0.75;
			step 			= function(monster, canSwitchState)
				return "attack-ready";
			end;
		}; ["dead"] = {
			animationEquivalent = "death";
			transitionLevel 	= math.huge;
			stopTransitions 	= false;
			step 				= function(monster, canSwitchState)
				return nil
			end;
			execute = function()
				return nil
			end
		}; ["attacked-by-player"] = {
			transitionLevel = 1;
			step 			= function(monster)
				print("HELLO! :D", monster.closestEntity, monster.entityMonsterWasAttackedBy)
				if monster.closestEntity and (monster.targetEntityLockType or 0) <= 1 and monster.entityMonsterWasAttackedBy then

					local closestEntityDistance = utilities.magnitude(monster.entityMonsterWasAttackedBy.Position - monster.manifest.Position)
					if monster:isTargetEntityInLineOfSight(nil, false, monster.entityMonsterWasAttackedBy) then
						monster:setTargetEntity(monster.entityMonsterWasAttackedBy)

						return "following"
					end
				end

				return "idling"
			end
		}
	};
}
