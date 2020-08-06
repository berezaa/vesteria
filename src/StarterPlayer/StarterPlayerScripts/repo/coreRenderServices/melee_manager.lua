local melee_manager = {}

function melee_manager.PlayAnimation(animationSequenceName, characterEntityAnimationTracks, animationName, animationToBePlayed, extraData)

    if
        animationSequenceName == "staffAnimations" or
        animationSequenceName == "swordAnimations" or
        animationSequenceName == "daggerAnimations" or
        animationSequenceName == "greatswordAnimations" or
        animationSequenceName == "dualAnimations" or
        animationSequenceName == "swordAndShieldAnimations" or
        animationSequenceName == "axeAnimations" or
        animationSequenceName == "pickaxeAnimations"
        then
            local atkspd = (extraData and extraData.attackSpeed) or 0
            characterEntityAnimationTracks[animationSequenceName][animationName]:Play(0.1, 1, (1 + atkspd))
        else
            if characterEntityAnimationTracks[animationSequenceName] then
                if typeof(characterEntityAnimationTracks[animationSequenceName][animationName]) == "Instance" then
                    characterEntityAnimationTracks[animationSequenceName][animationName]:Play()
                elseif typeof(characterEntityAnimationTracks[animationSequenceName][animationName]) == "table" then
                    animationToBePlayed = animationToBePlayed[1]

                for _, obj in pairs(characterEntityAnimationTracks[animationSequenceName][animationName]) do
                    obj:Play()
                end
            end
        end
    end
end


return melee_manager