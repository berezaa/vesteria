local ca=game:GetService("Players")local da=script.Parent
local _b=require(da:WaitForChild("ChatConstants"))local ab={}ab.WindowDraggable=false;ab.WindowResizable=false
ab.ShowChannelsBar=false;ab.GamepadNavigationEnabled=false;ab.ShowUserOwnFilteredMessage=true
ab.ChatOnWithTopBarOff=false;ab.ScreenGuiDisplayOrder=0;ab.ShowFriendJoinNotification=true
ab.BubbleChatEnabled=true;ab.ClassicChatEnabled=true;ab.ChatWindowTextSize=19
ab.ChatChannelsTabTextSize=19;ab.ChatBarTextSize=19;ab.ChatWindowTextSizePhone=14
ab.ChatChannelsTabTextSizePhone=19;ab.ChatBarTextSizePhone=14;ab.DefaultFont=Enum.Font.SourceSansBold
ab.ChatBarFont=Enum.Font.SourceSansBold;ab.BackGroundColor=Color3.new(0.05,0.05,0.05)
ab.DefaultChatColor=Color3.new(1,1,1)ab.DefaultMessageColor=Color3.new(1,1,1)
ab.DefaultNameColor=Color3.new(1,1,1)ab.ChatBarBackGroundColor=Color3.new(0,0,0)
ab.ChatBarBoxColor=Color3.new(1,1,1)ab.ChatBarTextColor=Color3.new(0,0,0)
ab.ChannelsTabUnselectedColor=Color3.new(0,0,0)
ab.ChannelsTabSelectedColor=Color3.new(30 /255,30 /255,30 /255)ab.DefaultChannelNameColor=Color3.fromRGB(35,76,142)
ab.WhisperChannelNameColor=Color3.fromRGB(102,14,102)ab.ErrorMessageTextColor=Color3.fromRGB(245,50,50)
ab.MinimumWindowSize=UDim2.new(0.3,0,0.25,0)ab.MaximumWindowSize=UDim2.new(1,0,1,0)
ab.DefaultWindowPosition=UDim2.new(0,0,0,0)local bb=(7 *2)+ (5 *2)
ab.DefaultWindowSizePhone=UDim2.new(0.5,0,0.5,bb)ab.DefaultWindowSizeTablet=UDim2.new(0.4,0,0.3,bb)
ab.DefaultWindowSizeDesktop=UDim2.new(0.3,0,0.25,bb)ab.ChatWindowBackgroundFadeOutTime=0.5;ab.ChatWindowTextFadeOutTime=30
ab.ChatDefaultFadeDuration=0.8;ab.ChatShouldFadeInFromNewInformation=false;ab.ChatAnimationFPS=20.0
ab.GeneralChannelName="All"ab.EchoMessagesInGeneralChannel=true;ab.ChannelsBarFullTabSize=4
ab.MaxChannelNameLength=12;ab.RightClickToLeaveChannelEnabled=false
ab.MessageHistoryLengthPerChannel=50;ab.ShowJoinAndLeaveHelpText=false;ab.MaximumMessageLength=200
ab.DisallowedWhiteSpace={"\n","\r","\t","\v","\f"}ab.ClickOnPlayerNameToWhisper=true
ab.ClickOnChannelNameToSetMainChannel=true
ab.BubbleChatMessageTypes={_b.MessageTypeDefault,_b.MessageTypeWhisper}ab.WhisperCommandAutoCompletePlayerNames=true
local cb=Instance.new("BindableEvent")
local db=setmetatable({},{__index=function(_c,ac)return ab[ac]end,__newindex=function(_c,ac,bc)ab[ac]=bc;cb:Fire(ac,bc)end})rawset(db,"SettingsChanged",cb.Event)return db