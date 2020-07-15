
if game.Players.LocalPlayer:FindFirstChild("DataLoaded")then
script.Parent.Enabled=false else script.Parent.Enabled=true end;local bb=game:GetService("ReplicatedStorage")
local cb=require(bb.modules)local db=cb.load("network")local _c=cb.load("tween")
local ac=game:GetService("TeleportService")local bc=ac:GetLocalPlayerTeleportData()or{}
local cc=bc.arrivingFrom;local dc=bc.dataTimestamp;local _d=bc.playerAccessories
if cc then
script.Parent.Load.Visible=false;script.Parent.Body.Visible=true
script.Parent.Blackout.Visible=true;local cd=ac:GetTeleportSetting("dataSlot")if
_d and type(_d)=="string"then
_d=game:GetService("HttpService"):JSONDecode(_d)end
local dd=db:invokeServer("{1CB180D8-192B-4A5B-A375-7DEF18393276}",cd,dc,_d)if not dd then warn("Failed to autoload data from teleport")
script.Parent.Load.Visible=true end
local __a=Random.new(os.time())local a_a=cc;wait(1.5)
_c(script.Parent.Blackout,{"BackgroundTransparency"},1,1)
_c(script.Parent.Body,{"Position"},UDim2.new(-1,0,0,0),1)end;local ad=false
local function bd()
if not ad then ad=true;script.Parent.Load.Text="Loading..."
local cd=1
local dd=db:invokeServer("{1CB180D8-192B-4A5B-A375-7DEF18393276}",cd)
if not dd then script.Parent.Load.Text="Error!"wait(1)ad=false end;wait(0.5)script.Parent.Load.Text="Load Data"end end
script.Parent.Load.MouseButton1Click:connect(bd)spawn(function()wait(5)bd()end)wait(1)
game.Players.LocalPlayer:WaitForChild("DataLoaded")script.Parent.Enabled=false