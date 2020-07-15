local cb={}local db={}db.__index=db;local _c=1 /3
local ac=game:GetService("ReplicatedStorage"):FindFirstChild("statusEffectsV3")local bc=game:GetService("HttpService")
local cc=game:GetService("ReplicatedStorage")local dc=require(cc.modules)
local _d=dc.load("entityUtilities")local ad=dc.load("network")local bd=dc.load("events")local cd={}
local function dd(__a)if __a.__event then
warn("attempt to hook statusEffect twice")return end
local a_a=Instance.new("BindableEvent")__a.__event=a_a
if not __a.isActive then a_a.Event:wait()end
if __a.__onStatusEffectBegan then __a.__onStatusEffectBegan(__a)end;local b_a=_c
while
__a.isActive and __a.timeElapsed<__a.data.duration do
if __a.isPaused then a_a.Event:wait()else
b_a=math.clamp(b_a,0,__a.data.duration-__a.timeElapsed)__a.timeElapsed=__a.timeElapsed+b_a;if __a.__onStatusEffectTick then
__a.__onStatusEffectTick(__a,b_a)end;b_a=wait(_c)end end;__a:stop()end
function db:start()if self.isActive==nil then
warn("statusEffect is uninitialized")return elseif self.isActive then return end
self.isActive=true;self.isPaused=false;self.__event:Fire()end;function db:pause()self.isPaused=true end
function db:stop()if self.__event then
self.isActive=false;self.__event=nil;cd[self.guid]=nil
self.__onStatusEffectEnded(self)end end
function db:serialize()self:stop()self.entity=nil
if
script:FindFirstChild(self.type)then local __a=require(script[self.type])for a_a,b_a in pairs(self)do if __a[a_a]then self[a_a]=
nil end end end end;function cb.getStatusEffectByGUID(__a)return cd[__a]end
function cb.getStatusEffectByLabel(__a)for a_a,b_a in pairs(cd)do if
b_a.label==__a then return b_a end end;return nil end
function cb.createStatusEffect(__a,a_a,b_a,c_a,d_a)
if
not __a or not __a:FindFirstChild("state")or __a.state.Value=="dead"then return end;if not ac:FindFirstChild(b_a)then return end
local _aa=require(ac[b_a])local aaa=_d.getEntityGUIDByEntityManifest(__a)local baa=a_a and
_d.getEntityGUIDByEntityManifest(a_a)local caa=d_a and
cb.getStatusEffectByLabel(d_a)
if caa then if _aa.doesStack then
caa.stacks=caa.stacks+1 end;caa.timeElapsed=0;return caa else local daa={}daa.isActive=false
daa.id=b_a;daa.timeElapsed=0;daa.data=c_a;daa.tempData={}
daa.guid=bc:GenerateGUID(false)daa.label=d_a;daa.stacks=1;daa.targetEntityGUID=aaa
daa.sourceEntityGUID=baa;for _ba,aba in pairs(_aa)do daa[_ba]=aba end;setmetatable(daa,db)coroutine.wrap(function()
dd(daa)end)()
cd[daa.guid]=daa;return daa end end
function cb.deserializeStatusEffect(__a,a_a)if
getmetatable(__a)or __a.isActive or __a.__event then
warn("attempt to deserialize an initiated statusEffect")return end;if
ac:FindFirstChild(__a.id)then local b_a=require(ac[__a.id])
for c_a,d_a in pairs(b_a)do __a[c_a]=d_a end end;__a.entity=a_a
setmetatable(__a,db)
coroutine.wrap(function()dd(__a)end)()end
ad:create("{12D4E6E2-19FE-4E19-9CEB-5A3866E5A252}","BindableFunction","OnInvoke",cb.createStatusEffect)
bd:registerForEvent("statusEffectStopped",function(__a)cd[__a.guid]=nil end)
bd:registerForEvent("entityManifestDied",function(__a)
local a_a=_d.getEntityGUIDByEntityManifest(__a)
if a_a then for b_a,c_a in pairs(cd)do
if c_a.targetEntityGUID==a_a then c_a:stop()cd[b_a]=nil end end end end)return cb