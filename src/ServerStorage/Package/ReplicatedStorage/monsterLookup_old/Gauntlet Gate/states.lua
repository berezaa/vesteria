local da=game:GetService("ReplicatedStorage")
local _b=require(da.modules)local ab=_b.load("pathfinding")local bb=_b.load("utilities")
local cb=_b.load("detection")local db=_b.load("network")local _c=1;local ac=Random.new()
return
{processDamageRequest=function(bc,cc)
return cc,"physical","direct"end,default="idling",states={["setup"]={animationEquivalent="idling",transitionLevel=0,step=function(bc)end},["sleeping"]={transitionLevel=1,step=function(bc,cc)
end},["idling"]={transitionLevel=2,step=function(bc,cc)end},["wait-roaming"]={transitionLevel=3,step=function(bc,cc)end},["direct-roam"]={transitionLevel=3,step=function(bc,cc)
end},["roaming"]={transitionLevel=3,step=function(bc,cc)end},["following"]={transitionLevel=4,step=function(bc,cc)end},["attack-ready"]={transitionLevel=5,step=function(bc,cc)
end},["attacking"]={transitionLevel=6,step=function(bc,cc)end},["special-attacking"]={transitionLevel=7,step=function(bc,cc)
end},["micro-sleeping"]={transitionLevel=8,step=function(bc,cc)end},["special-recovering"]={transitionLevel=9,step=function(bc,cc)
end},["dead"]={animationEquivalent="death",transitionLevel=math.huge,stopTransitions=false,step=function(bc,cc)return nil end,execute=function()return nil end},["attacked-by-player"]={transitionLevel=1,step=function(bc)
end}}}