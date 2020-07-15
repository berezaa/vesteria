
local db=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local _c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ac=_c.load("projectile")local bc=_c.load("placeSetup")
local cc=_c.load("client_utilities")local dc=_c.load("network")local _d=_c.load("damage")
local ad=_c.load("detection")local bd=_c.load("utilities")
local cd=bc.getPlaceFolder("entities")local dd=game:GetService("HttpService")
local __a={id=29,name="Battle Cry",image="rbxassetid://2574647455",description="Aggro all enemies onto your character and temporarily break their defenses.",damageType="physical",windupTime=0.1,maxRank=10,cooldown=3,cost=10,statistics={[1]={damageMultiplier=0,range=200,cooldown=3,manaCost=35,defenseBreak=5},[2]={defenseBreak=10},[3]={defenseBreak=15,range=25},[4]={defenseBreak=20},[5]={range=30,defenseBreak=25}},damage=30,maxRange=30}
function __a._serverProcessAbilityHit(b_a,c_a,d_a,_aa,aaa)
if _aa and _aa:FindFirstChild("entityType")and
_aa.entityType.Value=="monster"then
dc:invoke("{32CCFE53-543A-4794-AD57-82DE027EA7E4}",_aa,b_a.Character.PrimaryPart,"ability",1)return true end;return false end;local function a_a()end
function __a:execute(b_a,c_a,d_a,_aa)
if not b_a:FindFirstChild("entity")then return end
local aaa=dc:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",b_a.entity)local baa=aaa["1"]and aaa["1"].manifest
if not baa then return end
local caa=b_a.entity.AnimationController:LoadAnimation(script.battleCryAnimation)local daa=caa.Stopped:connect(a_a)caa:Play()
if d_a and
b_a.entity.PrimaryPart then local _ba=c_a["ability-statistics"].range
local aba=_d.getDamagableTargets(game.Players.LocalPlayer)local bba=b_a.entity.PrimaryPart.Position
for cba,dba in pairs(aba)do if
(dba.Position-bba).magnitude<=_ba then
dc:fireServer("{FA49DA7F-FF25-45CB-9BD1-DEBA1A3DEF4D}",self.id,_aa,dba,"battle-cry")end end end end;return __a