local b={}
function b.init()
local function c()
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All,false)
spawn(function()wait()
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat,true)
game.StarterGui:SetCore("ChatBarDisabled",false)game.StarterGui:SetCore("ChatActive",true)end)end;c()end;return b