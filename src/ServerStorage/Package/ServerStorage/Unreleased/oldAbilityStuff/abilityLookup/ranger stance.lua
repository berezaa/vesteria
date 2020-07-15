
local _c=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local ac=game:GetService("Debris")
local bc=game:GetService("RunService")
local cc=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local dc=cc.load("network")local _d=cc.load("damage")
local ad=cc.load("placeSetup")local bd=cc.load("tween")local cd=cc.load("ability_utilities")
local dd=cc.load("utilities")local __a=cc.load("effects")local a_a=cc.load("detection")
local b_a=ad.awaitPlaceFolder("entities")
local c_a={id=44,name="Ranger's Stance",image="rbxassetid://4079577447",description="Toggled ability. Use mana to focus your shots for extra range and damage in single arrows. (Requires bow.)",mastery="",maxRank=10,statistics=cd.calculateStats{maxRank=10,static={cooldown=1,manaCost=0},staggered={damageBonus={first=2,final=5,levels={2,3,4,6,7,8,10}},dexAsCrit={first=0.1,final=0.25,levels={5,9}}},pattern={manaPerSecond={base=3,pattern={0.5,0.5,0.5,2}}}},securityData={},equipmentTypeNeeded="bow"}
function c_a:execute_server(d_a,_aa,aaa)if not aaa then return end;if not d_a.Character then return end
local baa=d_a.Character.PrimaryPart;if not baa then return end
local caa=dd.getEntityGUIDByEntityManifest(baa)if not caa then return end
local daa=dc:invoke("{12EE4C27-216F-434F-A9C3-6771B8E6F6CF}",caa)local _ba=nil
for aba,bba in pairs(daa)do if bba.statusEffectType=="ranger stance"then
_ba=bba.statusEffectGUID;break end end
if _ba then
dc:invoke("{7598B3E9-CD41-4A4D-845C-1A19A35ACBFB}",_ba)else local aba=_aa["ability-statistics"]local bba=aba.manaPerSecond
dc:fireAllClients("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}",_aa,self.id)
dc:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",baa,"ranger stance",{duration=nil,manaCost=bba,damageBonus=aba.damageBonus,modifierData={walkspeed_totalMultiplicative=-0.95,criticalStrikeChance=
(aba.dexAsCrit*_aa["_dex"])/100}},baa,"ability",self.id)end end
function c_a:execute_client(d_a)local _aa=cd.getCastingPlayer(d_a)if not _aa then return end
local aaa=_aa.Character;if not aaa then return end;local baa=aaa.PrimaryPart;if not baa then return end
local caa=dc:invoke("{D13D9151-7254-4ED9-8DEA-979E6B884458}",baa)if not caa then return end;local daa=caa.PrimaryPart;if not daa then return end
local _ba=script.buff:Clone()_ba.Parent=daa;_ba:Play()
ac:AddItem(_ba,_ba.TimeLength)local aba=Instance.new("Part")aba.Anchored=true
aba.CanCollide=false;aba.Shape=Enum.PartType.Ball;aba.Material="Neon"
aba.Color=Color3.fromRGB(72,107,85)aba.Size=Vector3.new(0,0,0)aba.Position=daa.Position
aba.Parent=b_a
bd(aba,{"Size","Transparency"},{Vector3.new(8,8,8),1},1)ac:AddItem(aba,1)end
function c_a:execute(d_a,_aa,aaa,baa)if aaa then
dc:invokeServer("{7EE4FFC2-5AFD-40AB-A7C0-09FE74A020C3}",_aa,self.id)end end;return c_a