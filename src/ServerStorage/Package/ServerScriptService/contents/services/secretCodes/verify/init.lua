local d={}local _a=game:GetService("HttpService")
local aa=require(script.key)
function d.Verify(ba,ca)
if ba:FindFirstChild("VerifyCooldown")==nil then
local da=Instance.new("BoolValue")da.Name="VerifyCooldown"da.Parent=ba
spawn(function()wait(10)
if da then da:Destroy()end end)local _b=ba:GetRankInGroup(1137635)
if
type(ca)=="string"and ca~=""then local ab={}ab["Verified"]=true;ab["Vesterian"]=true
local bb=_a:GetAsync(
"http://104.236.92.94:8005/process?userId="..ba.userId..
"&code="..ca..
"&doPromote="..tostring(_b==1).."&roles="..
_a:JSONEncode(ab).."&key="..aa)
if
string.lower(bb)=="true"or string.lower(bb)=="success"then return true else
game.ReplicatedStorage.Error:FireClient(ba,"Server denied code: Response: "..bb)return false end end else return false end end;return d