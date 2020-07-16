local bow_manager = {}

local modules = require(replicatedStorage:WaitForChild("modules"))
local projectile 	= modules.load("projectile")


function bow_manager.PlayAnimation(animationSequenceName)
    -- bows, make sure all other bow animations stop!
    if animationSequenceName == "bowAnimations" then
                        
        local currentWeaponManifest = network:invoke("getCurrentWeaponManifest")
        if currentWeaponManifest then
            currentWeaponManifest = currentWeaponManifest:IsA("Model") and currentWeaponManifest.PrimaryPart or currentWeaponManifest
        end
        
        animationInterface:stopPlayingAnimationsByAnimationCollectionName(characterEntityAnimationTracks, "bowAnimations")
        
        if animationName == "stretching_bow_stance" then
            renderEntityData.currentPlayerWeaponAnimations.stretch:Play(nil, nil, 1)
            utilities.playSound("bowDraw", currentWeaponManifest)
            
            local arrow = assetFolder.arrow:Clone()
            renderEntityData.stanceArrow = arrow
            arrow.arrowWeld.Part0 = renderEntityData.currentPlayerWeapon.slackRopeRepresentation
            arrow.arrowWeld.C0 = CFrame.Angles(-math.pi / 2, 0, 0) * CFrame.new(0, (-arrow.Size.Y/2) - 0.1, 0)
            arrow.Parent = entitiesFolder
        
        elseif animationName == "firing_bow_stance" then
            local stanceArrowSpeed = 400
            local stanceArrowGravity = 0
            
            renderEntityData.currentPlayerWeaponAnimations.fire:Play()
            utilities.playSound("bowFireStance", currentWeaponManifest)
            
            local shotCFrame = CFrame.new()
            local visualArrow = renderEntityData.stanceArrow
            renderEntityData.stanceArrow = nil
            if visualArrow then
                shotCFrame = visualArrow.CFrame
                visualArrow:Destroy()
            end
            
            local function ringEffect(cframe, size)
                size = size or 1
                
                local ring = script:FindFirstChild("ring"):Clone()
                                    
                ring.CFrame = cframe * CFrame.Angles(math.pi/2,0,0)
                ring.Size = Vector3.new(2, 0.2, 2) * size
                ring.Parent = entitiesFolder
                
                local duration = 0.5
                tween(ring, {"Size"}, {ring.Size * 4 * size}, duration, Enum.EasingStyle.Quad)
                tween(ring, {"Transparency"}, {1}, duration, Enum.EasingStyle.Linear)
                game:GetService("Debris"):AddItem(ring, duration)
            end
            
            local arrow = assetFolder.arrow:Clone()
            arrow.Anchored = true
            arrow.CFrame = shotCFrame
            arrow.Trail.Enabled = true
            arrow.Trail.Lifetime = 1.5
            arrow.Trail.WidthScale = NumberSequence.new(1, 8)
            arrow.Parent = entitiesFolder
            
            local unitDirection = (extraData["mouse-target-position"] - shotCFrame.Position).Unit
            
            local targetsHit = {}
            
            ringEffect((CFrame.new(Vector3.new(), unitDirection) + shotCFrame.Position) * CFrame.new(0, 0, -2))
            
            local lifetime = 10
            --game:GetService("Debris"):AddItem(arrow, lifetime)
            
            local ringLast = tick()
            local ringTime = 0.05
            
            projectile.createProjectile(
                shotCFrame.Position,
                unitDirection,
                stanceArrowSpeed,
                arrow,
                function(hitPart, hitPosition, hitNormal, hitMaterial)
                    local canDamageTarget, target = damage.canPlayerDamageTarget(game.Players.LocalPlayer, hitPart)
                    if canDamageTarget and target then
                        if not targetsHit[target] then
                            targetsHit[target] = true
                            
                            utilities.playSound("bowArrowImpact", arrow)
                            ringEffect(arrow.CFrame * CFrame.Angles(math.pi / 2, 0, 0))
                            
                            if associatePlayer == client and canDamageTarget then
                                network:fire("requestEntityDamageDealt", target, hitPosition, "equipment", nil, "ranger stance")
                            end
                        end
                        
                        return true
                    else
                        arrow.Trail.Enabled = false
                        game:GetService("Debris"):AddItem(arrow, arrow.Trail.Lifetime)
                    end
                end,
                function(t)
                    local since = tick() - ringLast
                    if since >= ringTime then
                        ringLast = tick()
                        ringEffect(arrow.CFrame * CFrame.Angles(math.pi / 2, 0, 0), 0.4)
                    end
                
                    return CFrame.Angles(math.pi / 2, 0, 0)
                end,
                projectile.makeIgnoreList{
                    entityManifest,
                    renderEntityData.entityContainer,
                },
                true,
                stanceArrowGravity,
                lifetime
            )
            print(renderEntityData.entityContainer:GetFullName())
            
        elseif animationName == "stretching_bow" then
            if renderEntityData.firingAnimationStoppedConnection then
                renderEntityData.firingAnimationStoppedConnection:disconnect()
                renderEntityData.firingAnimationStoppedConnection = nil
            end
            
            local bowPullBackTime 	= configuration.getConfigurationValue("bowPullBackTime")
            local atkspd 			= (extraData and extraData.attackSpeed) or 0
            
            renderEntityData.bowStrechAnimationStopped = renderEntityData.currentPlayerWeaponAnimations.stretch.Stopped:connect(onBowStrechingAnimationStopped)
            renderEntityData.currentPlayerWeaponAnimations.stretch:Play(
                0.1,
                1,
                (renderEntityData.currentPlayerWeaponAnimations.stretch.Length / bowPullBackTime) * (1 + atkspd)
            )
            
            utilities.playSound("bowDraw", currentWeaponManifest)
            
            local drawStartTime = tick()

            local numArrows = extraData.numArrows or 1
            local firingSeed = extraData.firingSeed or 1

            -- set-up the arrow
            renderEntityData.currentArrows = {}
            renderEntityData.firingSeed = firingSeed
            
            -- how far should each arrow be rotated from eachother
            local arrowAnglePadding = 3
            
            local startingAngle = -((numArrows - 1)*arrowAnglePadding)/2
            
            local closestAngleToZero = math.huge
            
            for i = 1, numArrows do
                local newArrow = assetFolder.arrow:Clone()
                
                newArrow.Parent = workspace.CurrentCamera
                
                local angleOffset = startingAngle + (i-1)*arrowAnglePadding
                
                table.insert(renderEntityData.currentArrows, {
                    arrow = newArrow,
                    angleOffset = angleOffset,
                    orientation = CFrame.Angles(0, math.pi, 0) * CFrame.Angles(math.pi/2,0,0) * CFrame.Angles(math.rad(angleOffset*3),0,0)
                })
                
                if math.abs(angleOffset) < closestAngleToZero then
                    renderEntityData.primaryArrow = newArrow -- used for auto-targeting in bow damage interface
                    closestAngleToZero = math.abs(angleOffset)
                end
            end
            
            renderEntityData.currentDrawStartTime 	= drawStartTime
            
            if utilities.doesPlayerHaveEquipmentPerk(associatePlayer, "overdraw") then
                --renderEntityData.currentArrow.Size = renderEntityData.currentArrow.Size * 2
                for _, arrowData in pairs(renderEntityData.currentArrows) do
                    local arrow = arrowData.arrow
                    arrow.Size = arrow.Size * 2
                end
            end
            
            -- I have no clue what this is for so I will not touch it ~nimblz
            delay(configuration.getConfigurationValue("maxBowChargeTime"), function()
                if renderEntityData.currentDrawStartTime == drawStartTime and renderEntityData.currentArrows then
                    for _, arrowData in pairs(renderEntityData.currentArrows) do
                        local arrow = arrowData.arrow
                        
                        arrow.Material 		= Enum.Material.Neon
                        arrow.BrickColor 	= BrickColor.new("Institutional white")
                    end
                end
            end)
            
            -- apply welds
            for _, arrowData in pairs(renderEntityData.currentArrows) do
                local arrow = arrowData.arrow
                
                arrow.arrowWeld.Part0 = renderEntityData.currentPlayerWeapon.slackRopeRepresentation
                arrow.arrowWeld.C0 = arrowData.orientation * CFrame.new(0, (-arrow.Size.Y/2) - 0.1, 0)
            end
            
            --local arrowHolder 	= renderEntityData.currentPlayerWeapon.slackRopeRepresentation.arrowHolder
            --arrowHolder.C0 		= CFrame.Angles(0, math.rad(180), 0) * CFrame.Angles(math.rad(45), 0, 0) * CFrame.Angles(math.rad(45), 0, 0) * CFrame.new(0, -renderEntityData.currentArrow.Size.Y / 2 - 0.1, 0)
            --arrowHolder.Part1 	= renderEntityData.currentArrow
            
            -- update state
            renderEntityData.weaponState = "streched"
            onEntityStateChanged(entityManifest.state.Value)
                                
            -- do this.. hehe
            if animationToBePlayed then
                if typeof(characterEntityAnimationTracks[animationSequenceName][animationName]) == "Instance" then
                    characterEntityAnimationTracks[animationSequenceName][animationName]:Play(
                        0.1,
                        1,
                        (renderEntityData.currentPlayerWeaponAnimations.stretch.Length / bowPullBackTime) * (1 + atkspd)
                    )
                elseif typeof(characterEntityAnimationTracks[animationSequenceName][animationName]) == "table" then
                    animationToBePlayed = animationToBePlayed[1]
                    
                    for i, obj in pairs(characterEntityAnimationTracks[animationSequenceName][animationName]) do
                        obj:Play(
                            0.1,
                            1,
                            (renderEntityData.currentPlayerWeaponAnimations.stretch.Length / bowPullBackTime) * (1 + atkspd)
                        )
                    end
                end
            end
            
            return
        elseif animationName == "firing_bow" and renderEntityData.currentArrows then
            if renderEntityData.bowStrechAnimationStopped then
                renderEntityData.bowStrechAnimationStopped:disconnect()
                renderEntityData.bowStrechAnimationStopped = nil
            end
                
            if renderEntityData.currentPlayerWeaponAnimations.stretch.IsPlaying then
                renderEntityData.currentPlayerWeaponAnimations.stretch:Stop()
            end
            
            if renderEntityData.currentPlayerWeaponAnimations.stretchHold.IsPlaying then
                renderEntityData.currentPlayerWeaponAnimations.stretchHold:Stop()
            end
            
            if extraData.canceled then
                for _, arrowData in pairs(renderEntityData.currentArrows) do
                    arrowData.arrow:Destroy()
                end
                
                renderEntityData.currentArrows = nil
                
                animationToBePlayed = nil
                
                -- force reset state
                renderEntityData.weaponState = nil
                onEntityStateChanged(entityManifest.state.Value)
            else
                local function onFiringAnimationStopped()
                    if renderEntityData.firingAnimationStoppedConnection then
                        renderEntityData.firingAnimationStoppedConnection:disconnect()
                        renderEntityData.firingAnimationStoppedConnection = nil
                    end
                    
                    -- update state
                    renderEntityData.weaponState = nil
                    onEntityStateChanged(entityManifest.state.Value)
                end
            
                renderEntityData.firingAnimationStoppedConnection = renderEntityData.currentPlayerWeaponAnimations.fire.Stopped:connect(onFiringAnimationStopped)
                renderEntityData.currentPlayerWeaponAnimations.fire:Play()
            
                utilities.playSound("bowFire", currentWeaponManifest)
                
                local isMagical = playerStats.int >= 30 -- Is magical, use AOE
                
                local explodeRadius = 1.5
                local explodeDurration = 1 / 4
                
                if playerStats.int >= 70 then
                    explodeRadius = 2.5
                end
                
                if playerStats.int >= 150 then
                    explodeRadius = 4
                    explodeDurration = 3 / 8
                end
                
                local maxPierces = utilities.calculatePierceFromStr(playerStats.str)
                local numArrows = #renderEntityData.currentArrows
                
                local arrowSpeed = (renderEntityData.weaponBaseData.projectileSpeed or 200) * math.clamp(extraData.bowChargeTime / configuration.getConfigurationValue("maxBowChargeTime"), 0.1, 1)
                
                local speedScalar = maxPierces - (numArrows/2)
                speedScalar = math.max(speedScalar, -1) -- this clamps slowest possible speed to 50% of default
                arrowSpeed = arrowSpeed + (arrowSpeed * speedScalar * 0.5) -- 50% speed buff per pierc
                
                if utilities.doesPlayerHaveEquipmentPerk(associatePlayer, "overdraw") then
                    arrowSpeed = arrowSpeed * 2
                end
                
                
                local unitDirection, adjusted_targetPosition = projectile.getUnitVelocityToImpact_predictiveByAbilityExecutionData(
                    renderEntityData.currentPlayerWeapon.slackRopeRepresentation.Position,
                    renderEntityData.weaponBaseData.projectileSpeed or 200, -- act as if you were shooting at full
                    extraData
                )
                
                local shotOrigin = CFrame.new(
                    renderEntityData.currentPlayerWeapon.slackRopeRepresentation.Position,
                    renderEntityData.currentPlayerWeapon.slackRopeRepresentation.Position + unitDirection
                ) * CFrame.new(0,0,-1.5)
                
                -- do launch effect
                if maxPierces > 0 then
                    local durration = 0.25
                    local newRing = script:FindFirstChild("ring"):Clone()
                                    
                    newRing.CFrame = shotOrigin * CFrame.new(0,0,-1) * CFrame.Angles(math.pi/2,0,0)
                    newRing.Size = Vector3.new(2, 0.2, 2)
                    newRing.Parent = workspace.CurrentCamera
                    
                    tween(newRing, {"Size"}, {Vector3.new(3 + (maxPierces*1),0.2,3 + (maxPierces*1))}, durration, Enum.EasingStyle.Quad)
                    tween(newRing, {"Transparency"}, {1}, durration, Enum.EasingStyle.Linear)
                    
                    local explosionBall = Instance.new("Part")
                    local scaler = Instance.new("SpecialMesh")
                    
                    explosionBall.Size = Vector3.new(3+maxPierces,3+maxPierces,2)
                    explosionBall.Color = Color3.fromRGB(255,255,255)
                    explosionBall.Anchored = true
                    explosionBall.CanCollide = false
                    explosionBall.Material = Enum.Material.Neon
                    explosionBall.CFrame = shotOrigin * CFrame.new(0,0,-1.5)
                    
                    scaler.MeshType = Enum.MeshType.Sphere
                    scaler.Parent = explosionBall
                    
                    explosionBall.Parent = workspace.CurrentCamera
                    
                    local finalLength = 6+(maxPierces*2)
                    
                    tween(explosionBall, {"Transparency"}, {1}, durration/2, Enum.EasingStyle.Linear)
                    tween(explosionBall, {"Size"}, {Vector3.new(0.5,0.5,finalLength)}, durration/2, Enum.EasingStyle.Quad)
                    tween(explosionBall, {"CFrame"}, {shotOrigin * CFrame.new(0,0,-(1.5 + finalLength/2))}, durration/2, Enum.EasingStyle.Quad)
                    
                    game:GetService("Debris"):AddItem(newRing, durration)
                    game:GetService("Debris"):AddItem(explosionBall, durration)
                end
                
                local arrowRandomizer = Random.new(renderEntityData.firingSeed)
                
                local guid = httpService:GenerateGUID(false)
                
                -- shoot arrows
                for _, arrowData in pairs(renderEntityData.currentArrows) do
                    local arrow = arrowData.arrow
                    arrow.arrowWeld:Destroy()
                    arrow.Anchored = true
                    
                    
                    local pierceCount = 0
                    local entityPierceBlacklist = {}
                    
    --								local unitDirection = -renderEntityData.currentArrow.CFrame.UpVector
                    local shotOrientation = CFrame.new(Vector3.new(0,0,0), unitDirection)
                    local displacedShotOrientation = shotOrientation
                    
                    
                    if numArrows < 4 then
                        displacedShotOrientation = shotOrientation *CFrame.Angles(
                            arrowRandomizer:NextNumber(-0.025, 0.025),
                            math.rad(arrowData.angleOffset),
                            0
                        )
    --								elseif numArrows == 4 then
    --									displacedShotOrientation = CFrame.Angles(
    --										math.random()*0.2 - 0.1,
    --										math.rad(arrowData.angleOffset),
    --										0
    --									) * shotOrientation
                    else
                        displacedShotOrientation = shotOrientation * CFrame.Angles(
                            math.rad(numArrows * 0.8) * arrowRandomizer:NextNumber(-1, 1),
                            math.rad(arrowData.angleOffset) + (math.rad(5) * arrowRandomizer:NextNumber(-1, 1)),
                            0
                        )
    --									displacedShotOrientation = CFrame.fromAxisAngle(Vector3.new(
    --										math.random()*2 - 1,
    --										math.random()*2 - 1,
    --										math.random()*2 - 1
    --										).Unit, math.random() * math.rad(10)) * shotOrientation
                    end
                    
                    local finalUnitDirection = displacedShotOrientation.LookVector
                    
                    if numArrows == 1 and pierceCount >= 1 then
                        finalUnitDirection = unitDirection
                    end
                    
                    if arrow:FindFirstChild("Trail") then
                        arrow.Trail.Enabled = true
                    end
                    
                    renderEntityData.currentDrawStartTime 	= nil
                    
                    projectile.createProjectile(
                        shotOrigin.Position,
                        finalUnitDirection,
                        arrowSpeed, --renderEntityData.weaponBaseData.projectileSpeed or 200,
                        arrow,
                        function(hitPart, hitPosition, hitNormal, hitMaterial)
                            --[[
                            if hitNormal then
                                currentArrow.CFrame = CFrame.new(hitPosition, hitPosition + hitNormal) * CFrame.Angles(-math.rad(90), 0, 0)
                            end
                            ]]
                            
                        
                            local function explode(needsToHit)
                                local explosionBall = Instance.new("Part")
                                local scaler = Instance.new("SpecialMesh")
                                
                                explosionBall.Size = Vector3.new(explodeRadius*2,explodeRadius*2,explodeRadius*2)
                                explosionBall.Shape = Enum.PartType.Ball
                                explosionBall.Color = Color3.fromRGB(255,255,255)
                                explosionBall.Anchored = true
                                explosionBall.CanCollide = false
                                explosionBall.Material = Enum.Material.Neon
                                explosionBall.CFrame = CFrame.new(hitPosition)
                                
                                scaler.Scale = Vector3.new(0,0,0)
                                scaler.MeshType = Enum.MeshType.Sphere
                                scaler.Parent = explosionBall
                                
                                explosionBall.Parent = workspace.CurrentCamera
                                
                                tween(explosionBall, {"Transparency"}, {1}, explodeDurration, Enum.EasingStyle.Linear)
                                tween(explosionBall, {"Color"}, {Color3.fromRGB(0,255,100)}, explodeDurration, Enum.EasingStyle.Linear)
                                tween(scaler, {"Scale"}, {Vector3.new(1,1,1) * 1.25}, explodeDurration, Enum.EasingStyle.Quint)
                                game:GetService("Debris"):AddItem(explosionBall, explodeDurration*1.15)
                                
                                -- do some AOE dmg
                                if associatePlayer == client then
                                    for i, v in pairs(damage.getDamagableTargets(client)) do
                                        local vSize = (v.Size.X + v.Size.Y + v.Size.Z)/6
                                        if (v.Position - hitPosition).magnitude <= (explodeRadius) + vSize and v ~= needsToHit then
                                            delay(0.1, function()
                                                network:fire("requestEntityDamageDealt", v, hitPosition, "equipment", nil, nil, guid)
                                            end)
                                        end
                                    end
                                    if needsToHit then
                                        delay(0.1, function()
                                            network:fire("requestEntityDamageDealt", needsToHit, hitPosition, "equipment", nil, nil, guid)
                                        end)
                                    end
                                end
                            end
                            
                            local function ring(initialTransparency, initialRadius, finalRadius, lifetime)
                                initialTransparency = initialTransparency or 3/4
                                initialRadius = initialRadius or 1
                                finalRadius = finalRadius or 2
                                lifetime = lifetime or 1/3
                                local newRing = script:FindFirstChild("ring"):Clone()
                                
                                newRing.CFrame = arrow.CFrame
                                newRing.Transparency = initialTransparency
                                newRing.Size = Vector3.new(initialRadius, 0.5, initialRadius)
                                newRing.Parent = workspace.CurrentCamera
                                
                                tween(newRing, {"Size"}, {Vector3.new(finalRadius,0.2,finalRadius)}, lifetime*1.15, Enum.EasingStyle.Quint)
                                tween(newRing, {"Transparency"}, {1}, lifetime, Enum.EasingStyle.Linear)
                                
                                game:GetService("Debris"):AddItem(newRing, lifetime*1.15)
                            end
                            
                            if hitPart then
                                if (hitPart:IsDescendantOf(entityRenderCollectionFolder) or hitPart:IsDescendantOf(entityManifestCollectionFolder)) then -- entity impact
                                    -- pierce check
                                    local canDamageTarget, trueTarget = damage.canPlayerDamageTarget(game.Players.LocalPlayer, hitPart)
                                    if trueTarget and not entityPierceBlacklist[trueTarget] then
                                        entityPierceBlacklist[trueTarget] = true
                                        
                                        
                                        if isMagical then
                                            -- play magic sound
                                            utilities.playSound("magicAttack", arrow)
                                        else
                                            utilities.playSound("bowArrowImpact", arrow)
                                        end
                                        
                                        if isMagical then -- do aoe dmg
                                            explode(trueTarget)
                                        else -- do direct damage
                                            if associatePlayer == client and canDamageTarget then -- we shot this arrow, dmg the entity
                                                network:fire("requestEntityDamageDealt", trueTarget, hitPosition, "equipment", nil, nil, guid)
                                            end
                                        end
                                        
                                        pierceCount = pierceCount + 1
                                        if pierceCount <= maxPierces then -- did pierce an entity
                                            local intensity = maxPierces - (pierceCount-1)
                                            intensity = math.clamp(intensity,1,8)
                                            
                                            local intensityCalls = {
                                                function() ring(2/3, 	1, 		2,		1/3) end, -- 1
                                                function() ring(1/2, 	1.25, 	3,		1/3) end, -- 2
                                                function() ring(1/3, 	1.5, 	4,		1/2) end, -- 3
                                                function() ring(1/4, 	2, 		5,		1/2) end, -- 4
                                                function() ring(1/5, 	1.5, 	6,		1/2) end, -- 5
                                                function() ring(1/8, 	2, 		7,		2/3) end, -- 6
                                                function() ring(1/8, 	2.5, 	7.5,	2/3) end, -- 7
                                                function() ring(0, 		3, 		8,		2/3) end, -- 8
                                            }
                                            
                                            (intensityCalls[intensity] or intensityCalls[3])()
                                            
                                            return true
                                        else
                                            arrow.Anchored = false
                                            weld(arrow, hitPart)
                                            game:GetService("Debris"):AddItem(arrow, 3)
                                            return false
                                        end
                                    elseif trueTarget and entityPierceBlacklist[trueTarget] then
                                        return true
                                    end
                                    
                                    
                                else -- world impact
                                    if arrow:FindFirstChild("impact") then
                                        local hitColor = hitPart.Color
                                        if hitPart == workspace.Terrain then
                                            if hitMaterial ~= Enum.Material.Water then
                                                hitColor = hitPart:GetMaterialColor(hitMaterial)
                                            else
                                                hitColor = BrickColor.new("Cyan").Color
                                            end
                                        end
                                        
                                        local emitPart = Instance.new("Part")
                                        emitPart.Size = Vector3.new(0.1,0.1,0.1)
                                        emitPart.Transparency = 1
                                        emitPart.Anchored = true
                                        emitPart.CanCollide = false
                                        emitPart.CFrame = (arrow.CFrame - arrow.CFrame.p) + hitPosition
                                        local impact = arrow.impact:Clone()
                                        impact.Parent = emitPart
                                        emitPart.Parent = workspace.CurrentCamera
                                        impact.Color = ColorSequence.new(hitColor)
                                        impact:Emit(10)
                                        game:GetService("Debris"):AddItem(emitPart,3)
                                        game:GetService("Debris"):AddItem(arrow, 3)
                                        tween(arrow, {"Transparency"}, {1}, 3, Enum.EasingStyle.Linear)
                                    end
                                    if isMagical then
                                        explode()
                                    end
                                    return false
                                end
                            end
                        end,
                        
                        function(t)
                            return CFrame.Angles(math.rad(90), 0, 0)
                        end,
                        
                        -- ignore list
                        {entityManifest; renderEntityData.entityContainer},
                        
                        -- points to next position
                        true
                    )
                            
                    renderEntityData.currentArrows = nil
                end
                
                
            end
        else
            
    end
end


return bow_manager