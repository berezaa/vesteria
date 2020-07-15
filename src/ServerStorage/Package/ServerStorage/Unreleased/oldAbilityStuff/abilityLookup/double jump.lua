
local _b=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local ab=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local bb=ab.load("projectile")local cb=ab.load("placeSetup")
local db=ab.load("client_utilities")local _c=ab.load("network")
local ac=cb.awaitPlaceFolder("entityManifestCollection")
local bc={cost=1,maxRank=1,layoutOrder=3,requirement=function(dc)return dc.class=="Hunter"end}
local cc={id=7,metadata=bc,passive=true,layoutOrder=0,name="Double Jump",image="rbxassetid://3736597758",description="Grants you the ability to jump in mid-air!",statistics={[1]={tier=1}},maxRank=1}return cc