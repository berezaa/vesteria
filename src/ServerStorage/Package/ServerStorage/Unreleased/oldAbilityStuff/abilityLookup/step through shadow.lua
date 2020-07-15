
local bc=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local cc=game:GetService("Debris")
local dc=game:GetService("RunService")
local _d=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ad=_d.load("network")local bd=_d.load("damage")
local cd=_d.load("placeSetup")local dd=_d.load("tween")
local __a=_d.load("ability_utilities")local a_a=_d.load("effects")local b_a=_d.load("detection")
local c_a=cd.awaitPlaceFolder("entities")
local d_a={id=53,name="Step Through Shadow",image="rbxassetid://92931029",description="Create a shadow at your location. If you have a shadow already, immediately warp back to it. Doesn't break stealth.",mastery="Longer window of time to reactivate.",maxRank=3,statistics=__a.calculateStats{maxRank=3,static={cooldown=15},dynamic={manaCost={10,50},duration={15,45}}},securityData={},doesNotBreakStealth=true}
local function _aa(caa)local daa=Instance.new("Model")
for _ba,aba in
pairs(caa:GetDescendants())do
if aba:IsA("BasePart")then local bba=aba:Clone()
for cba,dba in pairs(bba:GetChildren())do if(not
dba:IsA("SpecialMesh"))then dba:Destroy()end end;bba.Anchored=true
if bba.Transparency<1 then bba.Color=Color3.new(0,0,0)
bba.Transparency=0.5;bba.Material=Enum.Material.SmoothPlastic end;bba.Parent=daa
if aba==caa.PrimaryPart then daa.PrimaryPart=bba end end end;return daa end;local aaa="StepThroughShadowActiveTag"local function baa()
local caa=game:GetService("HttpService")local daa=caa:GenerateGUID()
return"StepThroughShadowShadow_"..daa end
function d_a:execute_server(caa,daa,_ba)if
not _ba then return end;local aba=caa.Character;if not aba then return end
local bba=aba.PrimaryPart;if not bba then return end;local cba=caa:FindFirstChild(aaa)
if cba then
ad:invoke("{DBDAF4CE-3206-4B42-A396-15CCA3DFE8EC}",caa,cba.CFrame.Value)
ad:fireAllClients("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}",daa,self.id,"removeShadow",cba.Value)
ad:fireAllClients("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}",daa,self.id,"disappearShadow")cba:Destroy()else cba=Instance.new("StringValue")
cba.Name=aaa;cba.Value=baa()local dba=Instance.new("CFrameValue")
dba.Name="CFrame"dba.Value=bba.CFrame;dba.Parent=cba;cba.Parent=caa
ad:fireAllClients("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}",daa,self.id,"createInitialShadow",cba.Value)
ad:invoke("{5517DD42-A175-4E6C-8DD5-842CB17CE9F3}",caa,self.id)
delay(daa["ability-statistics"]["duration"],function()
if cba.Parent~=caa then return end
ad:fireAllClients("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}",daa,self.id,"removeShadow",cba.Value)cba:Destroy()end)end end
function d_a:execute_client(caa,daa,...)self[daa](self,caa,...)end
function d_a:createInitialShadow(caa,daa)local _ba=__a.getCastingPlayer(caa)
if not _ba then return end;local aba=_ba.Character;if not aba then return end;local bba=aba.PrimaryPart
if not bba then return end
local cba=ad:invoke("{CA09ED16-A4C8-4148-9701-4B531599C9E9}",bba)if not cba then return end;local dba=cba:FindFirstChild("entity")if not dba then
return end;local _ca=cba.PrimaryPart;if not _ca then return end;local aca=_aa(dba)
aca.Name=daa;aca.Parent=c_a end
function d_a:disappearShadow(caa)local daa=__a.getCastingPlayer(caa)if not daa then return end
local _ba=daa.Character;if not _ba then return end;local aba=_ba.PrimaryPart;if not aba then return end
local bba=ad:invoke("{CA09ED16-A4C8-4148-9701-4B531599C9E9}",aba)if not bba then return end;local cba=bba:FindFirstChild("entity")if not cba then
return end;local dba=bba.PrimaryPart;if not dba then return end;local _ca=_aa(cba)
_ca.Parent=c_a;local aca=0.5
for bca,cca in pairs(_ca:GetDescendants())do if cca:IsA("BasePart")then
dd(cca,{"Transparency"},1,aca)end end;cc:AddItem(_ca,aca)end;function d_a:removeShadow(caa,daa)local _ba=c_a:FindFirstChild(daa)if not _ba then return end
_ba:Destroy()end
function d_a:execute(caa,daa,_ba,aba)
local bba=caa.PrimaryPart;if not bba then return end;local cba=caa:FindFirstChild("entity")if not cba then
return end;if _ba then
ad:fireServer("{7170F8E2-9C53-42D1-A10A-E8383DB284E0}",daa,self.id)end end;return d_a