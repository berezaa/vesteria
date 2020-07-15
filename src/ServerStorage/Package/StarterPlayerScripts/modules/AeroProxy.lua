local _a={}local aa=game:GetService("ReplicatedStorage")
local ba=require((aa.modules))local ca=ba.load("network")function _a.getGameSaveData(da)
local _b,ab=ca:invokeServer("{382D6FC6-8F3C-45EE-936D-EBEB74BF5928}")return ab end
function _a.renderCharacter(da,_b,ab)return
ca:invoke("{01474D9A-12D0-4C30-90B0-649477E2B77A}",da,_b,ab)end
function _a.getMovementAnimationForCharacter(da,_b)
local ab=da.entity:WaitForChild("AnimationController")
local bb=ca:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",da.entity)local cb
do if bb[1]then cb=bb[1].baseData.equipmentType end end
return ca:invoke("{F22A757B-3CF2-4CEE-ACF2-466C636EF6BB}",ab,_b,cb,nil)end;return _a