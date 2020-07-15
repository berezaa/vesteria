
local bb=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local cb=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local db=cb.load("projectile")local _c=cb.load("placeSetup")
local ac=cb.load("client_utilities")local bc=cb.load("network")local cc=cb.load("utilities")
local dc=game:GetService("Debris")local _d=game:GetService("HttpService")
local ad={id=10,name="Ablaze",activeEffectName="Ablaze",styleText="On fire (and not in a good way).",description="",image="rbxassetid://2528902271",notSavedToPlayerData=true}local bd=256
function ad.onStarted_server(cd,dd)local __a=Instance.new("Attachment")
__a.Position=Vector3.new(0,0,0)__a.Parent=dd;local a_a=script.emitter:Clone()
a_a.Parent=__a;cd.__emitterAttachment=__a end
function ad.onEnded_server(cd,dd)local __a=cd.__emitterAttachment;if not __a then return end
local a_a=__a:FindFirstChild("emitter")if not a_a then return end;a_a.Enabled=false
dc:AddItem(__a,a_a.Lifetime.Max)end
function ad.execute(cd,dd,__a)local a_a=dd:FindFirstChild("maxHealth")
if not a_a then return end
local b_a=a_a.Value*cd.statusEffectModifier.percent;local c_a=cd.statusEffectModifier.duration
local d_a=math.min(b_a/c_a,bd)local _aa=d_a/__a;if _aa<=0 then return end
local aaa=dd:FindFirstChild("entityType")if not aaa then return end;aaa=aaa.Value;local baa=cd.sourceEntityGUID
if not baa then return end;local caa=cc.getEntityManifestByEntityGUID(baa)
if not caa then return end;local daa=caa:FindFirstChild("entityType")if not daa then return end
daa=daa.Value;if daa~="character"then return end;local _ba=caa.Parent
local aba=game.Players:GetPlayerFromCharacter(_ba)if not aba then return end
local bba={damage=_aa,sourceType="status",sourceId=ad.id,damageType="magical",sourcePlayerId=aba.UserId,sourceEntityGUID=cd.sourceEntityGUID}
if aaa=="monster"then
bc:invoke("{031BE66E-62B6-4583-B409-DCB61C0DA077}",aba,dd,bba)else
bc:invoke("{AC8B16AA-3BD2-4B7F-B12C-5558B8857745}",aba,dd,bba)end;local cba=dd:FindFirstChild("state")if not cba then return end
cba=cba.Value;if cba=="dead"then ad.onEnded_server(cd,dd)end end;return ad