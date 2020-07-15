local c={}function c.show()end;local d=60
function c.init(_a)local aa=_a.network;local ba=_a.tween;local ca=_a.focus
local da=_a.utilities;local _b=_a.money;local ab=_a.levels
if
game.Lighting:FindFirstChild("deathEffect")then game.Lighting.deathEffect:Destroy()end;if game.Lighting:FindFirstChild("deathBlur")then
game.Lighting.deathBlur:Destroy()end
local function bb()
local _c=aa:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","gold")
local ac=aa:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","exp")
local bc=aa:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","level")local cc=ab.getEXPToNextLevel(bc)
local dc=math.min(ac,cc*0.2)script.Parent.curve.exp.Text="-"..
da.formatNumber(dc).." XP"_b.setLabelAmount(script.Parent.curve.cost,
-_c*0.1)end;spawn(function()bb()end)local cb=false
aa:invoke("{AC36B45C-65E9-405C-B6C1-E88A3F28A29E}",false)
function c.accept()if cb then
aa:fireServer("{07334FE6-6852-4306-B683-A0F5E3B3CB7C}")cb=false end end
function c.show()cb=true;ca.close()
local _c=Instance.new("ColorCorrectionEffect")_c.Saturation=0;_c.Name="deathEffect"_c.Parent=game.Lighting;ba(_c,{"Saturation","Contrast"},{
-1,0.1},0.1)
local ac=Instance.new("BlurEffect")ac.Size=0;ac.Enabled=true;ac.Name="deathBlur"ac.Parent=game.Lighting
ba(ac,{"Size"},10,4)
aa:invoke("{AC36B45C-65E9-405C-B6C1-E88A3F28A29E}",true)
delay(4,function()if script.Parent and script:FindFirstChild("chorus")then
script.chorus:Play()end
script.Parent.gradient.ImageTransparency=1;script.Parent.gradient.BackgroundTransparency=1
ba(script.Parent.gradient,{"ImageTransparency"},0,1)script.Parent.Visible=true
script.Parent.curve.timer.progress.Size=UDim2.new(0,0,1,0)
ba(script.Parent.curve.timer.progress,{"Size"},UDim2.new(1,0,1,0),d,Enum.EasingStyle.Linear)wait(d)c.accept()end)end
script.Parent.curve.respawn.Activated:connect(c.accept)
aa:connect("{5C7009DB-4822-41F0-BA22-AC7C5CB51128}","OnClientEvent",c.show)local function db(_c,ac)
if _c=="gold"or _c=="level"or _c=="exp"then bb()end end
aa:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",db)end;return c