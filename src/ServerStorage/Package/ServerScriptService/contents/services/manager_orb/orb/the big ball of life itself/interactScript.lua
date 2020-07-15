local aa={}aa.isActive=false;aa.interactPrompt="Call out to the orb"
aa.instant=false;local ba;local ca;local da;local _b
function aa.init(ab)ab.enchant.open(script.Parent)if ca then
ca:Destroy()end;script.Parent.sound:Play()
ca=script.Parent.Parent.pulseBoy:Clone()ca.Name="pulseCopy"ca.Parent=script.Parent;ca.Transparency=1
ab.tween(ca.Mesh,{"Scale"},{Vector3.new(65,65,65)},0.7)ab.tween(ca,{"Transparency"},{0.5},1)if da then
da:Destroy()end
da=script.Parent.Parent.pulseBoyInvert:Clone()ca.Name="pulseCopy"da.Parent=script.Parent;da.Transparency=1
ab.tween(da.Mesh,{"Scale"},{Vector3.new(
-60,-60,-60)},1)ab.tween(da,{"Transparency"},{0.5},1)
script.Parent.spread:Emit(300)script.Parent.steady.Enabled=true
if ba then ba:Destroy()end
ba=script.Parent.ColorCorrection:Clone()local bb=ba.TintColor;ba.TintColor=Color3.new(1,1,1)
ba.Parent=game.Lighting;ab.tween(ba,{"TintColor"},{bb},0.7)if _b then
_b:Destroy()end;_b=script.Parent.Blur:Clone()
local cb=_b.Size;_b.Size=0;_b.Parent=game.Lighting
ab.tween(_b,{"Size"},{cb},0.7)end
function aa.close(ab)script.Parent.steady.Enabled=false
game.Debris:AddItem(ba,0.5)game.Debris:AddItem(ca,0.5)
game.Debris:AddItem(da,0.5)game.Debris:AddItem(_b,0.5)if ca then
ab.tween(ca,{"Transparency"},{1},0.5)end;if da then
ab.tween(da,{"Transparency"},{1},0.5)end;if ba then
ab.tween(ba,{"TintColor"},{Color3.new(1,1,1)},0.5)end;if _b then
ab.tween(_b,{"Size"},{0},0.5)end;ab.enchant.close()end;return aa