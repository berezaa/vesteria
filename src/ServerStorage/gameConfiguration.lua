-- overrides: uid is userId, pid is placeId
-- uid overrides are always superior, then pid overrides then the global value

--[[
if not game.ServerStorage:FindFirstChild("Kill") then
	spawn(function()	
		local replicatedStorage = game:GetService("ReplicatedStorage")
			local modules 			= require(replicatedStorage:WaitForChild("modules"))
				local network 			= modules.load("network")			
		local tag = Instance.new("BoolValue")
		tag.Name = "Kill"
		tag.Parent = game.ServerStorage
		for i,player in pairs(game.Players:GetPlayers()) do
			if player.Character and player.Character.PrimaryPart then
				player.Character.PrimaryPart.health.Value = -999
					local message = " had their life force ripped from them by Terul"
					local text = "☠ " .. player.Name .. " " .. message .. " ☠"
					network:fireAllClients("signal_alertChatMessage", {
						Text = text,
						Font = Enum.Font.SourceSansBold,
						Color = Color3.fromRGB(255, 130, 100),
					})				
						
			end
			delay(10, function()
				player:Kick()
			end)
		end
	end)
end
]]

--[[
-- test: running code on all servers
if not game.ServerStorage:FindFirstChild("moneyCheckPayloadRunning2") then
	spawn(function()
		warn("$ Starting money check payload")
		local replicatedStorage = game:GetService("ReplicatedStorage")
			local modules 			= require(replicatedStorage:WaitForChild("modules"))
				local network 			= modules.load("network")	
		warn("$ Money check payload loaded")
		
		local function playerDataCheck(player)
			if player and player:FindFirstChild("DataLoaded") then
				local playerData = network:invoke("getPlayerData", player)
				if playerData and (not playerData["goldwipe3/19"]) then
					local doKickPlayer
					if playerData.gold >= 1e9 then
						warn("$", player.Name, "money wiped.")
						local msg = "Wiping " .. math.floor(playerData.gold/1e6) .. "G from " .. player.Name
						network:invoke("reportError", player, "critical", msg)
						playerData.nonSerializeData.setPlayerData("gold", 0)
						doKickPlayer = true
					end	
					playerData.nonSerializeData.setPlayerData("goldwipe3/19", true)
					if doKickPlayer then
						delay(1, function()
							player:Kick("Your money has been wiped for exploiting and this incident has been reported to developers.")
						end)
					end
				end	
			end
		end
				
		for i,player in pairs(game.Players:GetPlayers()) do
			playerDataCheck(player)
		end
		network:connect("playerDataLoaded", "Event", playerDataCheck)
		
		warn("$ Money check payload ended")
	end)
	
	local tag = Instance.new("BoolValue")
	tag.Name = "moneyCheckPayloadRunning2"
	tag.Parent = game.ServerStorage
end

]]
return {
	gameDisplayMessage = {
		value = nil;
	
		overrides = {
			["pid:2376885433"] = nil;
			["pid:2064647391"] = nil; -- mushtown
		};
	};
	
	mirrorWorldVersion = {
		value = 52;
	};
	
	
	
	
	-------------------------------------------------------
	------------ SPOOKY NIGHT TIME UPDATE -----------------
	
	doUseNightTimeGiantSpawn = {
		value = false;
	
		overrides = {
			["pid:2061558182"] = true;
		};
	};
	
	doSpawnNightTimeVariants = {
		value = false;
	
		overrides = {
			["pid:2061558182"] = true;
		};
	};
	
	-------------------------------------------------------
	-------------------------------------------------------
	
	
	
	
	
	
	doDisableDamageData = {
		value = false;
	
		overrides = {
--			["pid:3806158069"] = true;
		};
	};
	
	doUseProperAnimationForLoadingPlace = {
		value = false;
	
		overrides = {
			["pid:2061558182"] = true;
		};
	}; --doUseMageRangeAttack
	
	mageManaDrainFromBasicAttack = {
		value = 3;
	};
	
	doUseMageRangeAttack = {
		value = true;
		
		overrides = {
			-- internal
			["pid:2061558182"] 	= true;
		};
	};
	
	doUseEnchantmentsV2 = {
		value = false;
		
		overrides = {
			-- internal
			["pid:2061558182"] 	= true;
		};
	};
	
	isStorageEnabled = {
		value = false;
		
		overrides = {
			-- nilgarf
			["pid:2119298605"] 	= true;
			-- nilgarf F2P
			["pid:4042577479"] 	= true;
			
			-- internal
			["pid:2061558182"] 	= true;
		};
	};
	
	abilityPVPDampening = {
		value = 0.5
	};
	
	activeStatusEffectTickTimePerSecond = {
		value = 5;
	};
	
	doUseNewPotionMechanic = {
		value = false;
		
		overrides = {
			-- internal
			["pid:2061558182"] 	= true;
		};
	};
	
	doFixNoHitboxSpawnCausingNoControl = {
		value = true;
		
		overrides = {
			["uid:13562546"] 	= true;
			
			-- redwood
			["pid:2376890690"] 	= true;
			
			-- nilgarf
			["pid:2119298605"] 	= true;
			
			-- scallop
			["pid:2471035818"] 	= true;
			
			-- enchanted
			["pid:2260598172"] 	= true;
			
			-- internal
			["pid:2061558182"] 	= true;
		};
	};
	
	doFixServerSideShadowCloneJutsu = {
		value = true;
		
		overrides = {
			["uid:13562546"] 	= true;
			
			-- redwood
			["pid:2376890690"] 	= true;
			
			-- nilgarf
			["pid:2119298605"] 	= true;
			
			-- scallop
			["pid:2471035818"] 	= true;
			
			-- enchanted
			["pid:2260598172"] 	= true;
			
			-- internal
			["pid:2061558182"] 	= true;
		};
	};
	
	timeForAnyonePickupItem = {
		value = 60 * 3;
	};
	
	doEnableCameraLockToggle = {
		value = true;
		
		overrides = {
			["pid:2061558182"] = true;
		};
	};
	
	doUseTrackerPartAsHitbox = {
		value = true;
		
		overrides = {
			["pid:2061558182"] = true;
		};
	};
	
	-- flag handles whether or not trading is enabled
	isTradingEnabled = {
		value = true;
		
		overrides = {

		}
	};
	
	isPvpTokenAwardEnabled = {
		value = true;
		overrides = {
			["pid:2061558182"] = true;
			["uid:5000861"] = true;
		}		
	};
	
	doUseAbilitySecurityData = {
		value = true;
		
		overrides = {
			-- colosseum
			["pid:2496503573"] = true;
			
			-- internal
			["pid:2061558182"] = true;
			
			-- farmlands
			["pid:2180867434"] = true;
		};
	};
	
	doCheckMonsterKillDistanceChangeForEXPAndLoot = {
		value = true;
		
		overrides = {
			-- internal
			["pid:2061558182"] = true;
			
			-- farmlands
			["pid:2180867434"] = true;
		};
	};
	
	isTeleportingExploitFixEnabled = {
		value = true;
		
		overrides = {
--			-- internal
--			["pid:2061558182"] = true;
--			
--			-- colosseum
--			["pid:2496503573"] = true;
--			
			-- spider lair
			["pid:3207211233"] = false;
--			
--			-- enchanted forest
--			["pid:2260598172"] = true;
--			
--			-- nilgarf sewers
--			["pid:2878620739"] = true;
--			
--			-- scallop shores
--			["pid:2471035818"] = true;
--			
--			-- farmlands
--			["pid:2180867434"] = true;
			
			["uid:13562546"] = true;
			["uid:13136539"] = true;
		}
	};
	
	server_doRedirectMaxHealthDeletions = {
		value = true;
	};
	
	server_TPExploitVelocityMultiplier = { -- previously 1.5
		value = 1.35;
	};
	
	server_TPExploitTimeWindow = {
		value = 10;
	};
	
	server_TPExploitScoreToFail = { -- previously 15
		value = 15;
	};
	
	bowSnapTargetMaxDistance = {
		value = 6;
	};
	
	-- the time of the pull back animation
	bowPullBackTime = {
		value = 1;
	};
	
	-- minimum time you need to charge the bow to get
	-- it to actually fire
	minBowChargeTime = {
		value = 0.25;
	};
	
	-- amount of time you need to charge the bow to get
	-- 100% of your damage
	maxBowChargeTime = {
		value = 0.7;
	};
	
	-- maximum amount of damage multiplier
	-- ie, setting to 1.25 will make it so if you charge long enough
	-- your attack will do 125% damage. setting this above 100% only works
	-- if you charge the bow past maxBowChargeTime
	bowMaxChargeDamageMultiplier = {
		value = 1.25;
	};
	
	doLogTPExploitersInPlayerDataFlags = {
		value = false;
	};
	
	-- handles what happens if someone is caught tping;
	-- "redirect"; "kick"; "suspicion"
	tpExploitPunishment = {
		value = "redirect";
	};
	
	-- how much suspicion is added if above is "suspicion"
	tpExploitPunishmentSuspicionAddAmount = {
		value = 25;
	};
	
	doNotApplyLevelMultiToPVP = {
		value = true;
		
		overrides = {
			["pid:2061558182"] = true;
		}
	};
	
	-- flag handles whether or not players can block
	isBlockingEnabled = {
		value = true;
		
		overrides = {
			["pid:2061558182"] = true;
		}
	};
	
	-- flag handles whether or not players can block
	isVITMitigationEnabled = {
		value = true;
		
		overrides = {
			["pid:2061558182"] = true;
		}
	};
	
	doUseAutoAimV2 = {
		value = false;
		
		overrides = {
			["pid:2061558182"] = true;
		}
	};
	
	doFixShadowCloneJutsu = {
		value = true;
		
		overrides = {
			["pid:2061558182"] = true;
		}
	};
	
	doStartRevokingCheatWeapons = {
		value = true;
		
		overrides = {
			["pid:2061558182"] = true;
		}
	};
	
	-- handles new zap logic
	doUseNewZapLogic = {
		value = true;
		
		overrides = {
			["uid:13562546"] = true;
		}
	};
	
	-- fixing the "shadow-clone" bug..
	doUseBandaidFixForPlayerClones = {
		value = true;
		
		overrides = {
			["uid:13562546"] = true;
		}
	};
	
	-- calculate new bottom attachment to fix trails being misleading
	doUseCalculateBottomAttachmentV2 = {
		value = true;
		
		overrides = {
			["uid:13562546"] = true;
		}
	};
	
	-- new player renderer logic (characterrenderer)
	useNewPlayerRendererLogic = {
		value = true;
		
		overrides = {
			["uid:13562546"] = true;
		}
	};
	
	-- new entity renderer logic
	useEntityRenderer = {
		value = true;
	};
	
	doShowDeveloperDebugStatements = {
		value = false;
		
		overrides = {
			["uid:13562546"] = true;
		}
	};
	
	-- how many arrows translate to one arrow part
	arrowsPerArrowPartVisualization = {
		value = 100;
	};
	
	-- how many arrow parts can an item stack/quiver have
	maxArrowPartsVisualization = {
		value = 10;
	};
	
	-- how often the game refreshes gameConfiguration updates
	gameConfigurationRefreshTimeInSeconds = {
		value = 10
	};
}