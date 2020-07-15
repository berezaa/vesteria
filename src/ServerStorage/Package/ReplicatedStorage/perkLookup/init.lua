local b={}
for c,d in pairs(script:GetChildren())do local _a=require(d)
for aa,ba in
pairs(_a.perks)do
if _a.sharedValues then for ca,da in pairs(_a.sharedValues)do ba[ca]=da end end;ba.folder=d.Name;b[aa]=ba end end;return b