local staff_manager = {}

local modules = require(replicatedStorage:WaitForChild("modules"))
local projectile 	= modules.load("projectile")


funnction staff_manager.PlayAnimation(animationToBePlayed,extraData,configuration)
    if animationToBePlayed and not extraData.noRangeManaAttack and configuration.getConfigurationValue("doUseMageRangeAttack", game.Players.LocalPlayer) then
        local magicBullet 		= assetFolder.mageBullet:Clone()
        magicBullet.CanCollide 	= false
        magicBullet.Parent 		= workspace.CurrentCamera
    --						magicBullet.CFrame 		= entityManifest.CFrame * CFrame.new(0, 0, -1.5)
        magicBullet.CFrame		= CFrame.new(renderEntityData.currentPlayerWeapon.magic.WorldPosition)

        local unitDirection, adjusted_targetPosition = projectile.getUnitVelocityToImpact_predictiveByAbilityExecutionData(
            magicBullet.Position,
            renderEntityData.weaponBaseData.projectileSpeed or 50, -- act as if you were shooting at full
            extraData,
            0.05
        )

        utilities.playSound("magicAttack", renderEntityData.currentPlayerWeapon)

        projectile.createProjectile(
            magicBullet.Position,
            unitDirection,
            renderEntityData.weaponBaseData.projectileSpeed or 40, --renderEntityData.weaponBaseData.projectileSpeed or 200,
            magicBullet,
            function(hitPart, hitPosition, hitNormal, hitMaterial)
                tween(magicBullet, {"Transparency"},1,0.5)
                for i,child in pairs(magicBullet:GetChildren()) do
                    if child:IsA("ParticleEmitter") or child:IsA("Light") then
                        child.Enabled = false
                    end
                end
                game.Debris:AddItem(magicBullet, 0.5)

                -- for damien: todo: hitPart is nil
                if associatePlayer == client and hitPart then
                    local canDamageTarget, trueTarget = damage.canPlayerDamageTarget(game.Players.LocalPlayer, hitPart)
                    if canDamageTarget and trueTarget then
                        --								   (player, entityManifest, 	damagePosition, sourceType, sourceId, 		guid)
                        network:fire("requestEntityDamageDealt", trueTarget, 		hitPosition, 	"equipment", nil, "magic-ball")
                    end
                end
            end,

            nil,

            -- ignore list
            {entityManifest; renderEntityData.entityContainer},

            -- points to next position
            true,

            0.01,

            0.8
        )

        if renderEntityData.currentPlayerWeapon and renderEntityData.currentPlayerWeapon:FindFirstChild("magic") and renderEntityData.currentPlayerWeapon.magic:FindFirstChild("castEffect") then
            renderEntityData.currentPlayerWeapon.magic.castEffect:Emit(1)
        end

    end
end

return bow_manager