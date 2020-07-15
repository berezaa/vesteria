local b=script.Parent.Parent;e=require(b).bit;if not e then
error("no bitwise support found",2)end
if e.rol and not e.lrotate then e.lrotate=e.rol end;if e.ror and not e.rrotate then e.rrotate=e.ror end;return e