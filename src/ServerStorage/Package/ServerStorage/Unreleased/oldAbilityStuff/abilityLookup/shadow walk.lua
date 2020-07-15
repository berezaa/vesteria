
local cb=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local db=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local _c=db.load("projectile")local ac=db.load("placeSetup")
local bc=db.load("client_utilities")local cc=db.load("network")local dc=db.load("damage")
local _d=db.load("ability_utilities")
local ad=ac.awaitPlaceFolder("monsterManifestCollection")local bd=ac.awaitPlaceFolder("entities")
local cd=game:GetService("HttpService")
local dd={id=14,manaCost=5,name="Shadow Walk",image="rbxassetid://4079576254",description="Become invisible, restoring stamina and moving faster. Your first attack immediately after breaking stealth deals extra damage.",maxRank=10,statusEffects={"stealth","hitBonus"},statistics=_d.calculateStats{maxRank=10,staggered={duration={first=2,final=6,levels={2,6,10}},cooldown={first=10,final=6,levels={3,7}},damageMultiplier={first=2,final=4,levels={4,8}},speedBonus={first=25,final=50,levels={5,9}}},pattern={manaCost={base=5,pattern={1,3,2,3}}}},statusEffectApplicationData={duration=8},doesNotBreakStealth=true}
function dd:startAbility_server(__a,a_a)
local b_a=cc:invoke("{1116BB97-A7FB-4554-BDEC-B014207542AD}",dd,cc:invoke("{85D4FB3D-CC96-464E-96A9-E796B8EA4DA5}",__a,dd.id))
local c_a,d_a=cc:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",__a.Character.PrimaryPart,"stealth",{duration=b_a["duration"],damageMultiplier=b_a["damageMultiplier"],modifierData={walkspeed_totalMultiplicative=
b_a["speedBonus"]/100}},__a.Character.PrimaryPart,"ability",self.id)
cc:fireClient("{E68719DC-5D55-4EF3-B970-EAACE3A872AB}",__a,"max",true)return c_a,d_a end;function dd:execute(__a,a_a,b_a,c_a)end;return dd