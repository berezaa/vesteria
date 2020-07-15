local c=game:GetService("Debris")
local d={id=22,name="Weakened by Venom",activeEffectName="Weakened by Venom",styleText="Weakened by the venom of a Stingtail Staff."}function d.onStarted_server(_a,aa)local ba=script.emitter:Clone()ba.Parent=aa
_a.__emitter=ba end;function d.onEnded_server(_a,aa)local ba=_a.__emitter;if not
ba then return end;ba.Enabled=false
c:AddItem(ba,ba.Lifetime.Max)end;return d