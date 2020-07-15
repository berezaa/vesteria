-- Node Metadata
-- Rocky28447
-- July 2, 2020



local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local RNG = Random.new()
local EffectsStorage = script.EffectsStorage

local IS_SERVER = RunService:IsServer()

return {
	
	DestroyOnDeplete = false;
	Durability = 4;
	Harvests = 1;
	IsGlobal = true;
	Replenish = 20;
	NodeCategory = "woodcutting";
	
	LootTable = {
		Drops = 1;
		Items = {
			[1] = {
				ID = 2;
				Chance = 1;
				Amount = function()
					return RNG:NextInteger(2, 3)
				end;
				Modifiers = function()
					return {}
				end
			};
		}
	};
	
	-- Used to define weapons that will deal MORE than 1 damage
	Effectiveness = {
		
	};
	
	Animations = {
--		OnHarvest = function(node, dropPoint)
--		end;
		
		OnDeplete = function(node)
			if IS_SERVER then
				wait(1.85)
			else
				local cf = node:GetPrimaryPartCFrame()
				
				node.Green.CanCollide = false
				node.Log.CanCollide = false
				node.Log.Sound.TimePosition = 0.2
				node.Log.Sound:Play()
				for i = 0, 1 , 1/100 do
					RunService.RenderStepped:Wait()
					node:SetPrimaryPartCFrame(cf:Lerp(cf * CFrame.Angles(math.rad(90), 0, 0), TweenService:GetValue(i, Enum.EasingStyle.Exponential, Enum.EasingDirection.In)))
				end
				
				node.Green.Transparency = 1
				node.Log.Transparency = 1
				node.Green.Leaves:Emit(node.Green.Leaves.Rate)
				node.Green.Wood:Emit(node.Green.Wood.Rate)
			end
				
		end;
		
		OnReplenish = function(node)
			node:SetPrimaryPartCFrame(CFrame.new(node:GetPrimaryPartCFrame().Position))
			node.Green.CanCollide = true
			node.Green.Transparency = 0
			node.Log.CanCollide = true
			node.Log.Transparency = 0
		end;
	}
}