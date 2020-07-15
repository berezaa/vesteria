local _a={}local aa={}
aa.color={b=BrickColor.Blue().Color}aa.font={sourceSansBold=Enum.Font.SourceSansBold}
local ba=game:GetService("LocalizationService")
local ca=ba:GetTranslatorForPlayer(game.Players.LocalPlayer)
spawn(function()local da,_b;local ab=0
repeat if _b then
warn("Failed to access cloud translations:",_b)wait(ab*3)end
da,_b=pcall(function()
ca=ba:GetTranslatorForPlayerAsync(game.Players.LocalPlayer)end)ab=ab+1 until da end)
function _a.translate(da,_b)_b=_b or game;return ca:Translate(_b,da)or da end
function _a.convertToVesteriaDialogueTable(da)local _b={}local ab={}
if da:sub(1,1)~="["then da="[]"..da end;if da:sub(#da,#da)~="]"then da=da.."[]"end
for bb,cb in
string.gmatch(da,"([%w%;%:%=]-)%](.-)%[")do local db={}db.text=cb
for _c,ac in string.gmatch(bb,"(%w+)%=(%w+)")do
if
(_c=="font"or _c=="f")then db.font=aa.font[ac]or Enum.Font.SourceSans elseif(
_c=="color"or _c=="c")then
db.textColor3=aa.color[ac]or Color3.fromRGB(255,255,255)end end;table.insert(_b,db)end;return _b end;return _a