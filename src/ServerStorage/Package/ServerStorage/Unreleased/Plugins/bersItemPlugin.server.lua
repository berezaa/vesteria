
assert(game.ReplicatedStorage:FindFirstChild("itemData"),"Vesteria Item Manager - item data not found")
local ab=DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float,true,true,200,300,150,150)
local bb=plugin:CreateDockWidgetPluginGui("TestWidget",ab)bb.Title="Vesteria Item Manager"local cb={}
local db=Instance.new("Frame")
db.BackgroundColor3=settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)db.Size=UDim2.new(1,0,0,30)db.Parent=bb
local _c=Instance.new("ScreenGui")_c.Name="bersItemPlugin_hover"_c.Parent=game.PluginGuiService;local ac
function sort()end
local function bc()if ac then ac:Destroy()end
ac=Instance.new("ScrollingFrame")
ac.BackgroundColor3=settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ScrollBarBackground)ac.Size=UDim2.new(1,0,1,-30)
ac.Position=UDim2.new(0,0,0,30)local ad=Instance.new("UIListLayout")
ad.SortOrder=Enum.SortOrder.LayoutOrder;function sort()
ad.SortOrder=(ad.SortOrder==Enum.SortOrder.LayoutOrder)and
Enum.SortOrder.Name or Enum.SortOrder.LayoutOrder end
ad.Parent=ac;local bd=0;local cd=0
local dd=require(game.ReplicatedStorage.itemData:Clone())
for __a,a_a in
pairs(game.ReplicatedStorage.itemData:GetChildren())do local b_a=dd[a_a.Name]local c_a=Instance.new("TextButton")
c_a.Size=UDim2.new(1,0,0,20)c_a.Text=""local d_a=Instance.new("UIListLayout")
d_a.FillDirection=Enum.FillDirection.Horizontal;d_a.VerticalAlignment=Enum.VerticalAlignment.Center
d_a.HorizontalAlignment=Enum.HorizontalAlignment.Left;d_a.Parent=c_a;d_a.SortOrder=Enum.SortOrder.LayoutOrder
d_a.Padding=UDim.new(0,3)local _aa=Instance.new("ImageLabel")
_aa.Size=UDim2.new(0,20,0,20)_aa.Image=b_a.image;_aa.BackgroundTransparency=1;_aa.Parent=c_a
local aaa=tostring(b_a.id)
if#aaa==2 then aaa="0"..aaa elseif#aaa==1 then aaa="00"..aaa end;local baa=Instance.new("TextLabel")
baa.Size=UDim2.new(0,50,0,20)baa.Text="ID: "..aaa.." - "baa.TextSize=17
baa.TextColor3=settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonText)baa.Font=Enum.Font.SourceSans
baa.TextXAlignment=Enum.TextXAlignment.Left;baa.BackgroundTransparency=1;baa.Parent=c_a
local caa=Instance.new("ImageLabel")caa.Size=UDim2.new(0,16,0,16)
caa.Image="rbxgameasset://Images/category_"..b_a.itemType
caa.ImageColor3=settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonText)caa.BackgroundTransparency=1;caa.Parent=c_a
local daa=Instance.new("TextLabel")daa.Size=UDim2.new(1,0,0,20)daa.Text=b_a.name;daa.TextSize=17
daa.TextColor3=settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonText)daa.Font=Enum.Font.SourceSansBold
daa.TextXAlignment=Enum.TextXAlignment.Left;daa.BackgroundTransparency=1;daa.Parent=c_a
bd=b_a.id>bd and b_a.id or bd;cd=cd+1;c_a.Name=b_a.itemType
c_a.BackgroundColor3=settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button)
c_a.BorderColor3=settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder)c_a.LayoutOrder=b_a.id
c_a.Activated:connect(function()
plugin:OpenScript(a_a)end)c_a.Parent=ac;table.insert(cb,c_a)end;ac.CanvasSize=UDim2.new(0,0,0,cd*20)ac.Parent=bb end;bc()local cc=Instance.new("UIListLayout")
cc.HorizontalAlignment=Enum.HorizontalAlignment.Center;cc.VerticalAlignment=Enum.VerticalAlignment.Center
cc.FillDirection=Enum.FillDirection.Horizontal;cc.Padding=UDim.new(0,5)cc.Parent=db
local dc=Instance.new("ImageButton")dc.Image="rbxassetid://61995002"
dc.BackgroundColor3=settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button)
dc.BorderColor3=settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder)dc.Size=UDim2.new(0,20,0,20)
dc.Activated:connect(bc)dc.Parent=db;local _d=Instance.new("ImageButton")
_d.Image="rbxassetid://38186580"
_d.BackgroundColor3=settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button)
_d.BorderColor3=settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder)_d.Size=UDim2.new(0,20,0,20)
_d.Activated:connect(function()sort()end)_d.Parent=db;print("Setup complete")