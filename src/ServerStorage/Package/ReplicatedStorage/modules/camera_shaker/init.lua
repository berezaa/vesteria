local db={}db.__index=db;local _c=debug.profilebegin;local ac=debug.profileend
local bc="CameraShakerUpdate"local cc=Vector3.new;local dc=CFrame.new;local _d=CFrame.Angles;local ad=math.rad
local bd=cc()local cd=require(script.CameraShakeInstance)
local dd=cd.CameraShakeState;local __a=cc(0.15,0.15,0.15)local a_a=cc(1,1,1)db.CameraShakeInstance=cd
db.Presets=require(script.CameraShakePresets)
function db.new(b_a,c_a)
assert(type(b_a)=="number","RenderPriority must be a number (e.g.: Enum.RenderPriority.Camera.Value)")
assert(type(c_a)=="function","Callback must be a function")
local d_a=setmetatable({_running=false,_renderName="CameraShaker",_renderPriority=b_a,_posAddShake=bd,_rotAddShake=bd,_camShakeInstances={},_removeInstances={},_callback=c_a},db)return d_a end
function db:Start()if(self._running)then return end;self._running=true;local b_a=self._callback
game:GetService("RunService"):BindToRenderStep(self._renderName,self._renderPriority,function(c_a)
_c(bc)local d_a=self:Update(c_a)ac()b_a(d_a)end)end
function db:Stop()if(not self._running)then return end
game:GetService("RunService"):UnbindFromRenderStep(self._renderName)self._running=false end
function db:Update(b_a)local c_a=bd;local d_a=bd;local _aa=self._camShakeInstances
for i=1,#_aa do local aaa=_aa[i]
local baa=aaa:GetState()
if(baa==dd.Inactive and aaa.DeleteOnInactive)then self._removeInstances[
#self._removeInstances+1]=i elseif
(baa~=dd.Inactive)then
c_a=c_a+ (aaa:UpdateShake(b_a)*aaa.PositionInfluence)
d_a=d_a+ (aaa:UpdateShake(b_a)*aaa.RotationInfluence)end end
for i=#self._removeInstances,1,-1 do local aaa=self._removeInstances[i]
table.remove(_aa,aaa)self._removeInstances[i]=nil end;return
dc(c_a)*_d(0,ad(d_a.Y),0)*_d(ad(d_a.X),0,ad(d_a.Z))end
function db:Shake(b_a)
assert(type(b_a)=="table"and b_a._camShakeInstance,"ShakeInstance must be of type CameraShakeInstance")
self._camShakeInstances[#self._camShakeInstances+1]=b_a;return b_a end
function db:ShakeSustain(b_a)
assert(type(b_a)=="table"and b_a._camShakeInstance,"ShakeInstance must be of type CameraShakeInstance")
self._camShakeInstances[#self._camShakeInstances+1]=b_a;b_a:StartFadeIn(b_a.fadeInDuration)return b_a end
function db:ShakeOnce(b_a,c_a,d_a,_aa,aaa,baa)local caa=cd.new(b_a,c_a,d_a,_aa)caa.PositionInfluence=(
typeof(aaa)=="Vector3"and aaa or __a)
caa.RotationInfluence=(
typeof(baa)=="Vector3"and baa or a_a)
self._camShakeInstances[#self._camShakeInstances+1]=caa;return caa end
function db:StartShake(b_a,c_a,d_a,_aa,aaa)local baa=cd.new(b_a,c_a,d_a)baa.PositionInfluence=(
typeof(_aa)=="Vector3"and _aa or __a)
baa.RotationInfluence=(
typeof(aaa)=="Vector3"and aaa or a_a)baa:StartFadeIn(d_a)
self._camShakeInstances[#self._camShakeInstances+1]=baa;return baa end;return db