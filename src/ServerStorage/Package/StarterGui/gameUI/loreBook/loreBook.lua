local ab={}local bb=game:GetService("ReplicatedStorage")
local cb=require(bb.modules)local db=cb.load("network")local _c=cb.load("utilities")local ac={}
ac.network=db;local bc=game.Players.LocalPlayer;local cc=1;local dc={}
local _d=script.Parent.bookHolder.pages.lore.info.textcontent
function ab.init(ad)
local function bd()
if dc[cc]and dc[cc].text then _d.Text=dc[cc].text;if cc>=#dc then cc=#dc
script.Parent.bookHolder.pages.lore.next.Visible=false else
script.Parent.bookHolder.pages.lore.next.Visible=true end;if cc<=1 then
cc=1
script.Parent.bookHolder.pages.lore.prev.Visible=false else
script.Parent.bookHolder.pages.lore.prev.Visible=true end;script.Parent.bookHolder.pages.lore.title.Text=
"Page "..cc;if dc[cc].openFunc then
dc[cc].openFunc(ac)end;return true end;return false end
local function cd(__a,a_a)
script.Parent.bookCover.ImageColor3=a_a or Color3.fromRGB(38,42,58)dc=__a;cc=1;local b_a=bd()if b_a then ab.open()end;return true end
local function dd()
db:create("{A75B33A6-D58B-4E6E-9D91-CD0D6FEA1EB3}","BindableFunction")
db:connect("{A75B33A6-D58B-4E6E-9D91-CD0D6FEA1EB3}","OnInvoke",cd)
db:connect("{D5401345-3E55-471E-972D-4660C27D729B}","OnClientEvent",cd)
script.Parent.bookHolder.pages.lore.next.MouseButton1Click:connect(function()if
cc<#dc then cc=cc+1;bd()end end)
script.Parent.bookHolder.pages.lore.prev.MouseButton1Click:connect(function()if
cc>1 then cc=cc-1;bd()end end)
script.Parent.close.MouseButton1Click:connect(function()
if
script.Parent.Visible then ad.focus.toggle(script.Parent)end end)end
function ab.open()
if not script.Parent.Visible then script.Parent.UIScale.Scale=(
ad.input.menuScale+.15 or 1.25)end;ad.focus.toggle(script.Parent)end;dd()end;return ab