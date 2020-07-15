
local _b=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local ab=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local bb=ab.load("projectile")local cb=ab.load("placeSetup")
local db=ab.load("client_utilities")local _c=ab.load("network")
local ac=cb.awaitPlaceFolder("monsterManifestCollection")local bc=game:GetService("HttpService")
local cc={id=6,name="Mystically Bound",activeEffectName="Mystically Bound",styleText="Mystically bound in place.",description="",image="rbxassetid://2528902271"}function cc.execute(dc,_d,ad)end
function cc.onStarted_server(dc,_d)
local ad=Instance.new("BodyPosition")ad.Name="MysticallyBoundBindingForce"
ad.Position=_d.Position+Vector3.new(0,8,0)ad.MaxForce=Vector3.new(1e9,1e9,1e9)ad.Parent=_d
dc.__binding=ad end
function cc.onEnded_server(dc,_d)if not dc.__binding then
warn("CRITICAL ERROR WITH MYSTICALLY BOUND\nCouldn't find binding force!")return end
dc.__binding:Destroy()end;return cc