local _b={}local ab={}local bb={d="1"}
local cb=game:GetService("HttpService")local db=game:GetService("ReplicatedStorage")
local _c=require(db.modules)local ac=_c.load("network")local bc=_c.load("utilities")
local function cc(dc,_d,ad)
if ad==nil then
local dd=ac:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",dc)
if dd and dd.globalData then ad=dd.globalData else return false end end;local bd={}local cd=false
if _d.ProductId==509935760 then
ad.ethyr=(ad.ethyr or 0)+300;cd=true
spawn(function()
ac:invoke("{DC1AA741-408D-49CF-87F9-CD63B55E82D7}",dc,"ethyr",300,"product:ethyr300")end)elseif _d.ProductId==509934399 then ad.ethyr=(ad.ethyr or 0)+120;cd=true
spawn(function()
ac:invoke("{DC1AA741-408D-49CF-87F9-CD63B55E82D7}",dc,"ethyr",120,"product:ethyr120")end)elseif _d.ProductId==509935018 then ad.ethyr=(ad.ethyr or 0)+750;cd=true
spawn(function()
ac:invoke("{DC1AA741-408D-49CF-87F9-CD63B55E82D7}",dc,"ethyr",750,"product:ethyr750")end)elseif _d.ProductId==539152241 then ad.ethyr=(ad.ethyr or 0)+3500;cd=true
spawn(function()
ac:invoke("{DC1AA741-408D-49CF-87F9-CD63B55E82D7}",dc,"ethyr",3500,"product:ethyr3500")end)end;return cd,ad,bd end
ac:create("{AC8010FE-86EF-4904-A51A-1F3D80B40CC1}","BindableFunction","OnInvoke",cc)
ac:create("{0E9E7DA5-244E-47C3-9F73-17ED32943B5F}","RemoteEvent")
if
game.PlaceId~=2376885433 and game.PlaceId~=2015602902 then
game:GetService("MarketplaceService").ProcessReceipt=function(dc)
local _d=game.Players:GetPlayerByUserId(dc.PlayerId)
if not _d then warn("aborted purchase due to missing player")return
Enum.ProductPurchaseDecision.NotProcessedYet end
if _d:FindFirstChild("DataSaveFailed")then
warn("aborted purchase due to save failure")return Enum.ProductPurchaseDecision.NotProcessedYet end;local ad=tick()repeat wait(0.1)until
_d==nil or _d.Parent~=game.Players or
ac:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",_d)or tick()-ad>15
local bd=ac:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",_d)
if bd==nil then warn("aborted purchase due to player missing")return
Enum.ProductPurchaseDecision.NotProcessedYet end;local cd=bd.globalData
if cd==nil then
warn("aborted purchase due to player global data missing")return Enum.ProductPurchaseDecision.NotProcessedYet end;ab[_d]=ab[_d]or{}local dd=ab[_d]dd.payments=dd.payments or{}
local __a;local a_a;local b_a;if dd.payments[dc.PurchaseId]then __a=true else
__a,a_a,b_a=ac:invoke("{AC8010FE-86EF-4904-A51A-1F3D80B40CC1}",_d,dc,cd)end
if __a and a_a then
bd.nonSerializeData.setPlayerData("globalData",a_a)dd.payments[dc.PurchaseId]=true
spawn(function()if b_a.broadcast then
ac:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",b_a.broadcast)end
local c_a=bb[dc.ProductId]
if c_a==nil then
local d_a=game.MarketplaceService:GetProductInfo(dc.ProductId,Enum.InfoType.Product)
if d_a then c_a=d_a.Name;bb[dc.ProductId]=c_a else c_a="unknown"end end
ac:invoke("{D6C785B6-5995-421C-8056-66CCDBA04C5C}",_d,"Product",c_a,dc.CurrencySpent)end)return Enum.ProductPurchaseDecision.PurchaseGranted end end end;return _b