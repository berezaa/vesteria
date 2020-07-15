
local function c(_a,aa,ba)ba=ba or 1;local ca=_a.minLevel or 1;local da=_a.equipmentSlot;local _b=(da==1 and 0.75)or(da==
8 and 1)or 1.5;return math.ceil((
ba*ca)/ (5 *_b))end
local d={worn={prefix="Worn",color=Color3.fromRGB(148,148,148),valueMulti=0.75,modifier=function(_a,aa)local ba=-c(_a,aa,0.5)end},tattered={prefix="Tattered",color=Color3.fromRGB(148,148,148),valueMulti=0.75,modifier=function(_a,aa)return{defense=
- (c(_a,aa)+1)}end},dull={prefix="Dull",color=Color3.fromRGB(148,148,148),valueMulti=0.75,modifier=function(_a,aa)return{baseDamage=
- (c(_a,aa,0.75)+1)}end},keen={prefix="Keen",color=Color3.fromRGB(135,186,213),valueMulti=1.25,modifier=function(_a,aa)return
{int=c(_a,aa)}end},fierce={prefix="Fierce",color=Color3.fromRGB(190,143,109),valueMulti=1.25,modifier=function(_a,aa)return
{str=c(_a,aa)}end},swift={prefix="Swift",color=Color3.fromRGB(190,130,179),valueMulti=1.25,modifier=function(_a,aa)return
{dex=c(_a,aa)}end},vibrant={prefix="Vibrant",color=Color3.fromRGB(194,127,128),valueMulti=1.25,modifier=function(_a,aa)return
{vit=c(_a,aa)}end},pristine={prefix="Pristine",color=Color3.fromRGB(150,45,202),valueMulti=1.75,modifier=function(_a,aa)
local ba=_a.equipmentSlot;if ba==1 then
return{baseDamage=c(_a,aa,0.75 *0.7),wisdom=c(_a,aa,0.4)/100}elseif ba==8 then
return{defense=c(_a,aa,0.7),wisdom=c(_a,aa,0.4)/100}end end},legendary={prefix="Legendary",color=Color3.fromRGB(225,176,28),valueMulti=3,modifier=function(_a,aa)
local ba=_a.equipmentSlot;if ba==1 then
return{baseDamage=c(_a,aa,0.75 *1.2),wisdom=c(_a,aa,0.6)/100}elseif ba==8 then
return{defense=c(_a,aa,1.2),wisdom=c(_a,aa,0.6)/100}end end}}return d