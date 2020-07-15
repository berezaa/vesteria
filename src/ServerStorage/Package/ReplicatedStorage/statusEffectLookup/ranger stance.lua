
local cb=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local db=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local _c=db.load("projectile")local ac=db.load("placeSetup")
local bc=db.load("client_utilities")local cc=db.load("network")local dc=db.load("events")
local _d=game:GetService("Debris")
local ad=require(game.ReplicatedStorage.itemData)local bd=game:GetService("HttpService")
local cd={id=7,name="Ranger's Stance",activeEffectName="Ranger's Stance",styleText="In ranger's stance.",description="",image="rbxassetid://2528902271",notSavedToPlayerData=true}local function dd(__a,a_a)for b_a,c_a in pairs(__a:GetPlayingAnimationTracks())do if c_a.Animation==a_a then
return c_a end end
return nil end
function cd.__clientApplyTransitionEffectOnCharacter(__a)
local a_a=__a:FindFirstChild("entity")if not a_a then return end
local b_a=a_a:FindFirstChild("AnimationController")if not b_a then return end
local c_a=b_a:LoadAnimation(cb.rangerStanceStarting)c_a.Looped=true;c_a:Play()
delay(c_a.Length-0.05,function()
if not c_a.IsPlaying then return end;local d_a=b_a:LoadAnimation(cb.rangerStanceIdling)
d_a:Play(0)c_a:Stop(0)end)end
function cd.__clientRemoveStatusEffectOnCharacter(__a)local a_a=__a:FindFirstChild("entity")if not a_a then
return end
local b_a=a_a:FindFirstChild("AnimationController")if not b_a then return end
local c_a=b_a:LoadAnimation(cb.rangerStanceExiting)c_a:Play(0)local d_a=dd(b_a,cb.rangerStanceStarting)if d_a then
d_a:Stop(0)end;local _aa=dd(b_a,cb.rangerStanceIdling)if _aa then
_aa:Stop(0)end end
function cd.onStarted_server(__a,a_a)local b_a=Instance.new("Attachment")
b_a.Position=Vector3.new(0,-2,0)b_a.Parent=a_a;local c_a=script.emitter:Clone()
c_a.Parent=b_a;__a.__emitterAttachment=b_a
__a.__eventGuid=dc:registerForEvent("{0AF3C28A-B615-4B15-B2E3-3BDFF5E28CB0}",function(d_a)
local _aa=d_a.Character;if not _aa then return end;local aaa=_aa.PrimaryPart;if not aaa then return end;if aaa==a_a then
cc:invoke("{7598B3E9-CD41-4A4D-845C-1A19A35ACBFB}",__a.statusEffectGUID)end end)end
function cd.onEnded_server(__a,a_a)local b_a=__a.__emitterAttachment;if not b_a then return end
local c_a=b_a:FindFirstChild("emitter")if not c_a then return end;c_a.Enabled=false
_d:AddItem(b_a,c_a.Lifetime.Max)dc:deregisterEventByGuid(__a.__eventGuid)end
function cd.execute(__a,a_a,b_a)
local c_a=__a.statusEffectModifier.manaCost/b_a;local d_a=a_a:FindFirstChild("mana")if not d_a then return end;if
d_a.Value>=c_a then d_a.Value=d_a.Value-c_a else
cc:invoke("{7598B3E9-CD41-4A4D-845C-1A19A35ACBFB}",__a.statusEffectGUID)end
local _aa=game.Players:GetPlayerFromCharacter(a_a.Parent)
if _aa then
local aaa=cc:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",_aa)local baa=aaa.equipment
for caa,daa in pairs(baa)do
if daa.position==1 then local _ba=ad[daa.id]
if _ba then if
_ba.equipmentType~="bow"then
cc:invoke("{7598B3E9-CD41-4A4D-845C-1A19A35ACBFB}",__a.statusEffectGUID)end end end end end end;return cd