
local c=require(script.Parent.CameraShakeInstance)
local d={Bump=function()local _a=c.new(2.5,4,0.1,0.75)
_a.PositionInfluence=Vector3.new(0.15,0.15,0.15)_a.RotationInfluence=Vector3.new(1,1,1)return _a end,Explosion=function()
local _a=c.new(5,10,0,1.5)_a.PositionInfluence=Vector3.new(0.25,0.25,0.25)
_a.RotationInfluence=Vector3.new(4,1,1)return _a end,Earthquake=function()
local _a=c.new(0.6,3.5,2,10)_a.PositionInfluence=Vector3.new(0.25,0.25,0.25)
_a.RotationInfluence=Vector3.new(1,1,4)return _a end,BadTrip=function()
local _a=c.new(10,0.15,5,10)_a.PositionInfluence=Vector3.new(0,0,0.15)
_a.RotationInfluence=Vector3.new(2,1,4)return _a end,HandheldCamera=function()
local _a=c.new(1,0.25,5,10)_a.PositionInfluence=Vector3.new(0,0,0)
_a.RotationInfluence=Vector3.new(1,0.5,0.5)return _a end,Vibration=function()
local _a=c.new(0.4,20,2,2)_a.PositionInfluence=Vector3.new(0,0.15,0)
_a.RotationInfluence=Vector3.new(1.25,0,4)return _a end,RoughDriving=function()
local _a=c.new(1,2,1,1)_a.PositionInfluence=Vector3.new(0,0,0)
_a.RotationInfluence=Vector3.new(1,1,1)return _a end}
return
setmetatable({},{__index=function(_a,aa)local ba=d[aa]if(type(ba)=="function")then return ba()end
error(
"No preset found with index \""..aa.."\"")end})