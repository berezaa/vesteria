local d=game:GetService("LocalizationService")
local _a=game:GetService("Chat")local aa={_hasFetchedLocalization=false}
function aa:_getTranslator()
if not self._translator and not
self._hasFetchedLocalization then
self._hasFetchedLocalization=true;local ba=_a:WaitForChild("ChatLocalization",4)
if ba then
self._translator=ba:GetTranslator(d.RobloxLocaleId)
d:GetPropertyChangedSignal("RobloxLocaleId"):Connect(function()
self._hasFetchedLocalization=false;self._translator=nil end)else end end;return self._translator end;function aa:Get(ba,ca)local da=ca
pcall(function()local _b=self:_getTranslator()if _b then
da=_b:FormatByKey(ba)else end end)return da end;return
aa