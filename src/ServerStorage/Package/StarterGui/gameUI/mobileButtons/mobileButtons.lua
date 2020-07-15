local b={}
function b.init(c)local d=c.network
script.Parent.jump.Activated:Connect(function()
d:invoke("{ADF79FEF-4171-45E0-AE56-ED1CDDFCAF2E}")end)
script.Parent.pickup.InputBegan:Connect(function(_a)
c.itemAcquistion.pickupInputGained(_a)end)end;return b