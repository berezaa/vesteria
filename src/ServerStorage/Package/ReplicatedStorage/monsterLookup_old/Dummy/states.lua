local _b=game:GetService("ReplicatedStorage")
local ab=require(_b.modules)local bb=ab.load("pathfinding")local cb=ab.load("utilities")
local db=ab.load("detection")local _c=ab.load("network")local ac=1;local bc=Random.new()local cc={}
return
{processDamageRequest=function(dc,_d)return _d,"physical",
"direct"end,onDamageReceived=function(dc,_d,ad,bd)local cd=cc[dc]if not cd then
cd={start=tick()}cc[dc]=cd end;local dd=tick()cd.last=dd;cd.damage=
(cd.damage or 0)+bd
delay(3,function()if cd.last~=dd then return end
local __a=(cd.last-cd.start)if __a<1 then return end;local a_a=cd.damage/__a
a_a=math.floor(a_a*100)/100
_c:fireAllClients("{C14AEAAA-F0F8-41F3-A1F6-3C75E311F28C}",dc.dummyModel,a_a.." DPS","Dummy",Vector3.new(0,1,0),1)cc[dc]=nil end)end,default="idling",states={["setup"]={animationEquivalent="idling",transitionLevel=0,step=function(dc)
end},["sleeping"]={transitionLevel=1,step=function(dc,_d)end},["idling"]={transitionLevel=2,step=function(dc,_d)
end},["wait-roaming"]={transitionLevel=3,step=function(dc,_d)end},["direct-roam"]={transitionLevel=3,step=function(dc,_d)
end},["roaming"]={transitionLevel=3,step=function(dc,_d)end},["following"]={transitionLevel=4,step=function(dc,_d)end},["attack-ready"]={transitionLevel=5,step=function(dc,_d)
end},["attacking"]={transitionLevel=6,step=function(dc,_d)end},["special-attacking"]={transitionLevel=7,step=function(dc,_d)
end},["micro-sleeping"]={transitionLevel=8,step=function(dc,_d)end},["special-recovering"]={transitionLevel=9,step=function(dc,_d)
end},["dead"]={animationEquivalent="death",transitionLevel=math.huge,stopTransitions=false,step=function(dc,_d)return nil end,execute=function()return nil end},["attacked-by-player"]={transitionLevel=1,step=function(dc)
end}}}