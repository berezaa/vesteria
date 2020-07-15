local _a=require(game.ReplicatedStorage.modules)
local aa=_a.load("network")local ba=_a.load("events")
local ca={id=16,name="Taunted",activeEffectName="Taunted",styleText="Taunted and less resilient.",description="",image="rbxassetid://2528902271"}function ca.execute(da,_b,ab)local bb=da.statusEffectModifier.target
aa:invoke("{32CCFE53-543A-4794-AD57-82DE027EA7E4}",_b,bb,"status",3)end
return ca