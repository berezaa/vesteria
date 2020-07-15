local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))

	local network 			= modules.load("network")




local tweenService = game:GetService("TweenService")

local function tweenModel(model, CF, info)
	local CFrameValue = Instance.new("CFrameValue")
	CFrameValue.Value = model:GetPrimaryPartCFrame()

	CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
		model:SetPrimaryPartCFrame(CFrameValue.Value)
	end)
	
	local tween = tweenService:Create(CFrameValue, info, {Value = CF})
	tween:Play()
	
	tween.Completed:Connect(function()
		print("tween completed")
		CFrameValue:Destroy()
	end)
end





local dialogue = {
	id 			= "startTalkingTo";
	dialogue 	= {{text = "hi mister im bubbles!"}};
	sound      = "npc_male_old_uh_tiny";
	options 	= {
		{
			response 	= "How are you?";
			dialogue = {{text = "not so good, mister. everybody picks on me because of my glasses."}};
			options 	= {
				{
					response 	= "Don't worry about what other people think";
					dialogue = {{text = "oh, really? you think so?"}};
					options 	= {
						{
							response 	= "Everybody has their own insecurities";
							dialogue = {{text = "wow! i never thought of that before"}};
							options 	= {
								{
									response 	= "Don't let other people bring you down, buddy.";
									dialogue = {{text = "thanks mister! you're so nice!"}};
								};
							};
						};
					};
					
				};
				
			};
		};
		{
			response 	= "[Punt]";
			dialogue = {{text = "no please mister, don't do it!"}};
				options 	= {
					{
						response 	= "[Punt anyways]";
						dialogue = {{text = "but whyy?!! noooooo!!!!"}};
						onClose		= function(utilities)
							spawn(function()
							print("PLAYED")
							network:invoke("setCharacterArrested", true)
							local localCharacter = game.Players.LocalPlayer.Character
							local bodyGyro 		= localCharacter.PrimaryPart.hitboxGyro
							local bodyVelocity 	= localCharacter.PrimaryPart.hitboxVelocity
			
							bodyGyro.CFrame = CFrame.new(localCharacter.PrimaryPart.Position, Vector3.new(workspace.Bubbles.PrimaryPart.Position.X, localCharacter.PrimaryPart.Position.Y, workspace.Bubbles.PrimaryPart.Position.Z))
							
							
							
							for i, v in pairs(workspace.placeFolders.entityRenderCollection:GetChildren()) do
								if v.clientHitboxToServerHitboxReference.Value.Parent.Name == game.Players.LocalPlayer.Name then
									local punt = v.entity.AnimationController:LoadAnimation(script.punt)
									repeat wait() until punt.Length > 0
									punt.Looped = false
									punt:Play()
									spawn(function()
										wait(1.4)
										punt:Stop()
									end)
									break
								end
							end
							--local punt = game.Players.LocalPlayer.Character.AnimationController:LoadAnimation(script.punt)
							--local punt = renderEntityData.entityContainer.entity.AnimationController:LoadAnimation(script.punt)
							--punt:Play()
							
							wait(.4)
							
							workspace.Bubbles.hitsound:Play()
							workspace.Bubbles.scream:Play()
							game.CollectionService:RemoveTag(workspace.Bubbles, "interact")
							tweenModel(workspace.Bubbles, workspace.gnomepunt1.CFrame, TweenInfo.new(.3, Enum.EasingStyle.Linear))
							wait(.3)
							tweenModel(workspace.Bubbles, workspace.gnomepunt2.CFrame, TweenInfo.new(.3, Enum.EasingStyle.Linear))
							network:invoke("setCharacterArrested", false)
							--wait(.3)
							--workspace.Bubbles:Destroy()
							
							end)
						end;
					};
					{
						response 	= "Haha, just kidding";
						dialogue = {{text = "phewie! you had me real scared there mister."}};
						options 	= {
							{
								response 	= "[Punt anyways]";
								dialogue = {{text = "but whyy?!! noooooo!!!!"}};
								onClose		= function(utilities)
									spawn(function()
									print("PLAYED")
									network:invoke("setCharacterArrested", true)
									local localCharacter = game.Players.LocalPlayer.Character
									local bodyGyro 		= localCharacter.PrimaryPart.hitboxGyro
									local bodyVelocity 	= localCharacter.PrimaryPart.hitboxVelocity
					
									bodyGyro.CFrame = CFrame.new(localCharacter.PrimaryPart.Position, Vector3.new(workspace.Bubbles.PrimaryPart.Position.X, localCharacter.PrimaryPart.Position.Y, workspace.Bubbles.PrimaryPart.Position.Z))
									
									
									
									for i, v in pairs(workspace.placeFolders.entityRenderCollection:GetChildren()) do
										if v.clientHitboxToServerHitboxReference.Value.Parent.Name == game.Players.LocalPlayer.Name then
											local punt = v.entity.AnimationController:LoadAnimation(script.punt)
											repeat wait() until punt.Length > 0
											punt.Looped = false
											punt:Play()
											spawn(function()
												wait(1.4)
												punt:Stop()
											end)
											break
										end
									end
									--local punt = game.Players.LocalPlayer.Character.AnimationController:LoadAnimation(script.punt)
									--local punt = renderEntityData.entityContainer.entity.AnimationController:LoadAnimation(script.punt)
									--punt:Play()
									
									wait(.4)
									
									workspace.Bubbles.hitsound:Play()
									workspace.Bubbles.scream:Play()
									game.CollectionService:RemoveTag(workspace.Bubbles, "interact")
									tweenModel(workspace.Bubbles, workspace.gnomepunt1.CFrame, TweenInfo.new(.3, Enum.EasingStyle.Linear))
									wait(.3)
									tweenModel(workspace.Bubbles, workspace.gnomepunt2.CFrame, TweenInfo.new(.3, Enum.EasingStyle.Linear))
									network:invoke("setCharacterArrested", false)
									--wait(.3)
									--workspace.Bubbles:Destroy()
									
									end)
								end;
							};
						};
						};
				};

		};
		
	
	};
}
return dialogue