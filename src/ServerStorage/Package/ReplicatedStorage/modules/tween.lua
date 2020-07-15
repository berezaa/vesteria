
return
function(a,b,c,d,_a,aa)_a=_a or Enum.EasingStyle.Quad;aa=aa or
Enum.EasingDirection.Out;d=d or 0.5;local ba={}local ca=
(type(c)=="table"and true)or false;for ab,bb in pairs(b)do
ba[bb]=ca and c[ab]or c end;local da=TweenInfo.new(d,_a,aa)
local _b=game:GetService("TweenService"):Create(a,da,ba)_b:Play()return _b end