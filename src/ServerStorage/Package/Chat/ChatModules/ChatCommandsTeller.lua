local ba=game:GetService("Chat")
local ca=ba:WaitForChild("ClientChatModules")
local da=require(ca:WaitForChild("ChatSettings"))
local _b=require(ca:WaitForChild("ChatConstants"))local ab=nil
pcall(function()
ab=require(game:GetService("Chat").ClientChatModules.ChatLocalization)end)
if ab==nil then ab={Get=function(cb,db)return db end}end
local function bb(cb)local function db()
if da.ShowJoinAndLeaveHelpText~=nil then return da.ShowJoinAndLeaveHelpText end;return false end
local function _c(ac,bc,cc)
if(
bc:lower()=="/?"or bc:lower()=="/help")then
local dc=cb:GetSpeaker(ac)dc:SendSystemMessage("Vesteria chat commands:",cc)
dc:SendSystemMessage("    /me <text> :: roleplaying command for doing actions.",cc)
dc:SendSystemMessage("    /whisper <player> (/w) :: whisper a private message to a player.",cc)
dc:SendSystemMessage("    /mute <player> :: stop seeing chats from a player.",cc)
dc:SendSystemMessage("    /unmute <player> :: unmute a muted player.",cc)
dc:SendSystemMessage("    /party <text> (/p) :: send a message to party members.",cc)
dc:SendSystemMessage("    /invite <player> (/i) :: invite a player to your party.",cc)
dc:SendSystemMessage("    /duel <player> (/d) :: challenge a player to a duel.",cc)
dc:SendSystemMessage("    /trade <player> (/i) :: request a trade with a player.",cc)local _d=dc:GetPlayer()
if _d and _d.Team then
dc:SendSystemMessage(ab:Get("GameChat_ChatCommandsTeller_TeamCommand","/team <message> or /t <message> : send a team chat to players on your team."),cc)end;return true end;return false end
cb:RegisterProcessCommandsFunction("chat_commands_inquiry",_c,_b.StandardPriority)if da.GeneralChannelName then local ac=cb:GetChannel(da.GeneralChannelName)
if(ac)then end end end;return bb