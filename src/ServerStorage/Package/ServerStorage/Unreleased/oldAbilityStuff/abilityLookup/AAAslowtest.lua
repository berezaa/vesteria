
local _b=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local ab=game:GetService("Debris")
local bb=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local cb=bb.load("network")local db=bb.load("damage")
local _c=bb.load("placeSetup")local ac=bb.load("tween")
local bc=_c.awaitPlaceFolder("entities")
local cc={id=35,name="DESPACITO",image="http://www.roblox.com/asset/?id=2620812359",description="Yeetus McBeetus commit self deletus",mastery="Slowdown.",maxRank=1,statistics={[1]={cooldown=1,range=16,manaCost=0,duration=1,damageMultiplier=1.4,tier=1}},windupTime=1,securityData={playerHitMaxPerTag=64,projectileOrigin="character"},disableAutoaim=true}
function cc:execute_server(dc,_d,ad)if not dc.Character then return end
local bd=dc.Character.PrimaryPart;if not bd then return end
cb:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",bd,"ablaze",{percent=0.1,duration=8},bd,"environment",0)
cb:fireAllClients("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}",_d,self.id)end;function cc:execute_client(dc)end;function cc:execute(dc,_d,ad,bd)
cb:invokeServer("{7EE4FFC2-5AFD-40AB-A7C0-09FE74A020C3}",_d,self.id)end;return cc