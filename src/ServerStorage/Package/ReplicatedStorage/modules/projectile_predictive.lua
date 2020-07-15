local ad={}local bd={}local cd;local dd=game:GetService("RunService")
local __a=game.Players.LocalPlayer
local a_a=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local b_a=a_a.load("network")local c_a=a_a.load("placeSetup")
local d_a=a_a.load("utilities")local _aa=c_a.getPlaceFolder("entities")local aaa;local baa=3
local caa=Vector3.new(0,0.5 *60,0)local daa=tick()local _ba={}
local function aba(aca,bca,cca,dca,_da)local ada=_da-1 >0 and _da-1 or 0;local bda=(daa+baa/
cca*_da)-aca;local cda=
(daa+baa/cca* (ada))-aca
local dda=bca+dca*bda-caa*bda*bda;local __b=bca+dca*cda-caa*cda*cda
return workspace:FindPartOnRayWithIgnoreList(Ray.new(__b,
dda-__b),_ba)end
local function bba(aca,bca)
local cca,dca=workspace:FindPartOnRayWithIgnoreList(aca,bca)while cca and not cca.CanCollide do bca[#bca+1]=cca
cca,dca=workspace:FindPartOnRayWithIgnoreList(aca,bca)end;return cca,dca end
local function cba(aca)
for bca,cca in pairs(bd)do local dca=cca.velocity*aca-caa*aca*aca
if
d_a.magnitude(dca)>=baa then
for i=1,math.floor(d_a.magnitude(dca)/baa)do
local _da,ada=aba(cca.startTime,cca.origin,cca.speed,cca.velocity,i)
if cca.trackerPart then cca.trackerPart.CFrame=CFrame.new(ada)end
if _da then cca.collisionFunction(_da)cca.markForRemove=true end end end
if not cca.markForRemove then
local _da=(d_a.magnitude(dca)/baa)%1
if _da>0 then
local ada,bda=aba(cca.startTime,cca.origin,cca.speed,cca.velocity,_da)
if cca.trackerPart then cca.trackerPart.CFrame=CFrame.new(bda)end;if ada then cca.collisionFunction(ada)cca.markForRemove=true elseif tick()-
cca.startTime>3 then cca.collisionFunction(nil)
cca.markForRemove=true end end end;if cca.markForRemove then table.remove(bd,bca)end end;if#bd==0 then cd:disconnect()cd=nil end;daa=tick()end
function ad.createProjectile(aca,bca,cca,dca,_da)
table.insert(bd,{origin=aca,direction=bca,speed=cca,velocity=bca*cca,collisionFunction=_da,trackerPart=dca,startTime=tick()})if not cd then cd=dd.Heartbeat:connect(cba)end end;local function dba(aca)
aaa=b_a:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")_ba={aca,aaa,_aa}end
local function _ca()while not
game.Players.LocalPlayer do wait()end
__a=game.Players.LocalPlayer;if __a.Character then dba(__a.Character)end
__a.CharacterAdded:connect(dba)end;spawn(_ca)return ad