local _b=script.Parent.Parent
local ab=require(_b:WaitForChild("ChatConstants"))local bb=1;local cb="ProcessorType"local db="ProcessorFunction"local _c=0;local ac=1;local bc={}local cc={}
cc.__index=cc
function cc:SendSystemMessageToSelf(dc,_d,ad)
local bd={ID=-1,FromSpeaker=nil,SpeakerUserId=0,OriginalChannel=_d.Name,IsFiltered=true,MessageLength=string.len(dc),Message=dc,MessageType=ab.MessageTypeSystem,Time=os.time(),ExtraData=ad}_d:AddMessageToChannel(bd)end
function bc.new()local dc=setmetatable({},cc)dc.COMMAND_MODULES_VERSION=bb
dc.KEY_COMMAND_PROCESSOR_TYPE=cb;dc.KEY_PROCESSOR_FUNCTION=db;dc.IN_PROGRESS_MESSAGE_PROCESSOR=_c
dc.COMPLETED_MESSAGE_PROCESSOR=ac;return dc end;return bc.new()