local d={}local _a=script.Parent;local aa={}aa.__index=aa;function aa:SendMessage(ba,ca)
self.SayMessageRequest:FireServer(ba,ca)end;function aa:RegisterSayMessageFunction(ba)
self.SayMessageRequest=ba end;function d.new()local ba=setmetatable({},aa)ba.SayMessageRequest=
nil;return ba end;return d.new()