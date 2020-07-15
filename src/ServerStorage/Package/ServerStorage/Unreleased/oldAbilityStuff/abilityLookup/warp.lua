
local db=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local _c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ac=_c.load("projectile")local bc=_c.load("placeSetup")
local cc=_c.load("client_utilities")local dc=_c.load("network")
local _d=bc.awaitPlaceFolder("entityManifestCollection")local ad=bc.awaitPlaceFolder("entityRenderCollection")
local bd=bc.awaitPlaceFolder("entities")
local cd=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))local dd=game:GetService("HttpService")
local __a={id=25,name="Warp",image="rbxassetid://2528903781",description="Bring your character to wherever you click.",animationName={},windupTime=0.1,maxRank=1,statistics={[1]={distance=20,cooldown=4,manaCost=30}},dontDisableSprinting=true}function __a.__serverValidateMovement(b_a,c_a,d_a)return true end;local a_a=4
function __a:execute(b_a,c_a,d_a,_aa)if not
b_a:FindFirstChild("entity")then return end
dc:invokeServer("{0650EB64-0176-4935-9226-F83AA6EF8464}",c_a,__a.id,_aa)end
function __a:execute_server(b_a,c_a,d_a)
if
d_a and b_a.Character and b_a.Character.PrimaryPart then
b_a.Character.PrimaryPart.CFrame=CFrame.new(
c_a["absolute-mouse-world-position"]+Vector3.new(0,4,0))end end;return __a