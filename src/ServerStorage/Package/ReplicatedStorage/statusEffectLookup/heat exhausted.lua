
local ab=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local bb=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local cb=bb.load("projectile")local db=bb.load("placeSetup")
local _c=bb.load("client_utilities")local ac=bb.load("network")local bc=bb.load("utilities")
local cc=game:GetService("Debris")local dc=game:GetService("HttpService")
local _d={id=18,name="Heat Exhausted",activeEffectName="Heat Exhausted",styleText="Suffering from heat exhaustion.",description="",image="rbxassetid://334869557",hideInStatusBar=true,notSavedToPlayerData=true}function _d.execute(ad,bd,cd)end;return _d