local c={}local d={}function c.alert()end
function c.init(_a)
if
game.ReplicatedStorage:FindFirstChild("alertsOffset")then
script.Parent.Position=UDim2.new(0.5,0,0,
script.Parent.Position.Y.Offset+game.ReplicatedStorage.alertsOffset.Value)end;local aa=_a.tween;local ba=_a.network;local ca=_a.utilities
function c.alert(da,_b,ab)_b=_b or 4
if ab and
game.ReplicatedStorage.sounds:FindFirstChild(ab)then ca.playSound(ab)end;local bb=false;local cb
if da.id and d[da.id]then cb=d[da.id].alert
d[da.id].start=tick()else
cb=script.Parent:WaitForChild("{97822377-6CF7-4275-B2B8-3E4E2E50F11C}"):clone()bb=true
if da.id then d[da.id]={alert=cb,start=tick()}end end;cb.TextLabel.Text=da.text or da.Text or""
cb.TextLabel.TextColor3=
da.textColor3 or da.Color or Color3.new(1,1,1)
cb.TextLabel.TextStrokeColor3=da.textStrokeColor3 or Color3.new(0,0,0)
cb.TextLabel.Font=da.font or da.Font or Enum.Font.SourceSansBold
cb.TextLabel.BackgroundColor3=da.backgroundColor3 or Color3.new(1,1,1)
local db=game.TextService:GetTextSize(cb.TextLabel.Text,cb.TextLabel.TextSize,cb.TextLabel.Font,Vector2.new())cb.TextLabel.Size=UDim2.new(0,db.X+20,1,0)
cb.Parent=script.Parent;cb.Visible=true
if bb then local _c=da.textTransparency or 0
local ac=da.textStrokeTransparency or 0;local bc=da.backgroundTransparency or 1
cb.TextLabel.TextTransparency=1;cb.TextLabel.BackgroundTransparency=1
cb.TextLabel.TextStrokeTransparency=1
aa(cb.TextLabel,{"TextTransparency","TextStrokeTransparency","BackgroundTransparency"},{_c,ac,bc},0.5)else cb.TextLabel.TextTransparency=da.textTransparency or 0;cb.TextLabel.TextStrokeTransparency=
da.textStrokeTransparency or 0;cb.TextLabel.BackgroundTransparency=
da.backgroundTransparency or 1 end
spawn(function()wait(_b)
if da.id and d[da.id]then
if d[da.id].alert==cb then d[da.id]=nil
aa(cb.TextLabel,{"TextTransparency","TextStrokeTransparency","BackgroundTransparency"},{1,1,1},0.5)game.Debris:AddItem(cb,0.5)end elseif cb and cb.Parent==script.Parent then
aa(cb.TextLabel,{"TextTransparency","TextStrokeTransparency","BackgroundTransparency"},{1,1,1},0.5)game.Debris:AddItem(cb,0.5)end end)end
ba:create("{97822377-6CF7-4275-B2B8-3E4E2E50F11C}","BindableEvent","Event",c.alert)
ba:connect("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}","OnClientEvent",c.alert)end;return c