
local cb={cost=1,requirement=function(__a)return true end,variants={tripleSlash={cost=2,requirement=function(__a)return
__a.nonSerializeData.statistics_final.str>=10 end}}}local db=3
local _c=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local ac=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local bc=ac.load("projectile")local cc=ac.load("placeSetup")
local dc=ac.load("client_utilities")local _d=ac.load("network")
local ad=cc.awaitPlaceFolder("entityManifestCollection")local bd=game:GetService("HttpService")
local cd={id=db,metadata=cb,passive=true,name="Double Slash",image="rbxassetid://3736597154",description="Upgrades your Basic Attack.",statistics={[1]={tier=1}},maxRank=1}
local dd={id=db,metadata=cb,passive=true,name="Triple Slash",image="rbxassetid://3736597264",description="Upgrades your Basic Attack",statistics={[1]={tier=1}},maxRank=1}
function generateAbilityData(__a,a_a)a_a=a_a or{}if __a then local b_a;for c_a,d_a in pairs(__a.abilities)do if d_a.id==db then
b_a=d_a.variant end end
a_a.variant=b_a or"doubleSlash"end;if
a_a.variant=="tripleSlash"then return dd end;return cd end;return generateAbilityData