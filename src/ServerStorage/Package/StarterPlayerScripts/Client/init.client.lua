local b={}
for c,d in pairs(script:GetChildren())do b[d.Name]=require(d)end;for c,d in pairs(b)do if b.init then b.init(b)end end