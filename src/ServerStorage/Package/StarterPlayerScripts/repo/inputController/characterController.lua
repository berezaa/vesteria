local b={}b.__index=b
function b.new(c)local d=setmetatable({},b)
d.character=game.Players.LocalPlayer.Character;d.state=""d.animations={}
print(d.character:GetFullName())
d.events={["StateHandler"]=d.character.hitbox.state.Changed:Connect(function(_a)
d.state=_a end)}end;return b