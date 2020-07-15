
local bb=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local cb=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local db=cb.load("projectile")local _c=cb.load("placeSetup")
local ac=cb.load("client_utilities")local bc=cb.load("network")local cc=cb.load("damage")
local dc=cb.load("detection")local _d=_c.getPlaceFolder("entities")
local ad=game:GetService("HttpService")
local bd={id=30,name="Triple Slash",image="rbxassetid://3736597264",description="Unlocks the ability to triple slash with your sword.",damageType="physical",prerequisite={{id=3,rank=1}},layoutOrder=-1,windupTime=0.1,maxRank=5,cooldown=3,cost=10,passive=true,statistics={[1]={damageMultiplier=1.500},[2]={damageMultiplier=1.550},[3]={damageMultiplier=1.6},[4]={damageMultiplier=1.65},[5]={damageMultiplier=1.7}},damage=30,maxRange=30,equipmentTypeNeeded="sword"}return bd