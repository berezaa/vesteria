local d={}d.__index=d;local _a=Vector3.new;local aa=math.noise
d.CameraShakeState={FadingIn=0,FadingOut=1,Sustained=2,Inactive=3}
function d.new(ba,ca,da,_b)if(da==nil)then da=0 end;if(_b==nil)then _b=0 end
assert(type(ba)=="number","Magnitude must be a number")
assert(type(ca)=="number","Roughness must be a number")
assert(type(da)=="number","FadeInTime must be a number")
assert(type(_b)=="number","FadeOutTime must be a number")
local ab=setmetatable({Magnitude=ba,Roughness=ca,PositionInfluence=_a(),RotationInfluence=_a(),DeleteOnInactive=true,roughMod=1,magnMod=1,fadeOutDuration=_b,fadeInDuration=da,sustain=(da>0),currentFadeTime=(da>0 and 0 or 1),tick=Random.new():NextNumber(-100,100),_camShakeInstance=true},d)return ab end
function d:UpdateShake(ba)local ca=self.tick;local da=self.currentFadeTime;local _b=_a(aa(ca,0)*0.5,aa(0,ca)*0.5,
aa(ca,ca)*0.5)
if(
self.fadeInDuration>0 and self.sustain)then
if(da<1)then
da=da+ (ba/self.fadeInDuration)elseif(self.fadeOutDuration>0)then self.sustain=false end end
if(not self.sustain)then da=da- (ba/self.fadeOutDuration)end;if(self.sustain)then
self.tick=ca+ (ba*self.Roughness*self.roughMod)else
self.tick=ca+ (ba*self.Roughness*self.roughMod*da)end
self.currentFadeTime=da
return _b*self.Magnitude*self.magnMod*da end
function d:StartFadeOut(ba)if(ba==0)then self.currentFadeTime=0 end
self.fadeOutDuration=ba;self.fadeInDuration=0;self.sustain=false end
function d:StartFadeIn(ba)if(ba==0)then self.currentFadeTime=1 end;self.fadeInDuration=ba or
self.fadeInDuration;self.fadeOutDuration=0
self.sustain=true end;function d:GetScaleRoughness()return self.roughMod end;function d:SetScaleRoughness(ba)
self.roughMod=ba end
function d:GetScaleMagnitude()return self.magnMod end;function d:SetScaleMagnitude(ba)self.magnMod=ba end;function d:GetNormalizedFadeTime()return
self.currentFadeTime end
function d:IsShaking()return(
self.currentFadeTime>0 or self.sustain)end;function d:IsFadingOut()
return( (not self.sustain)and self.currentFadeTime>0)end
function d:IsFadingIn()return
(self.currentFadeTime<1 and
self.sustain and self.fadeInDuration>0)end
function d:GetState()
if(self:IsFadingIn())then return d.CameraShakeState.FadingIn elseif
(self:IsFadingOut())then return d.CameraShakeState.FadingOut elseif(self:IsShaking())then return
d.CameraShakeState.Sustained else return d.CameraShakeState.Inactive end end;return d