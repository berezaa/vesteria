local perkData = {
	sharedValues = {
		layoutOrder = 0;
		subtitle = "Equipment Perk";
		color = Color3.fromRGB(171, 47, 86);
	};
	perks = {
		["airborne"] = {
			title = "Airborne";
			description = "1.5x Basic Attack damage while jumping.";
			
			onDamageGiven = function(sourceManifest, sourceType, sourceId, targetManifest, ref_damageData)
				if sourceManifest:FindFirstChild("state") and sourceManifest.state.Value == "jumping" then
					if ref_damageData.sourceType == "equipment" then
						ref_damageData.damage = ref_damageData.damage * 1.5
					end
				end
			end;
		};
		
		["poisonblink"] = {
			title = "Spore Cloud";
			description = "Blink releases a cloud of poisonous spores.";
		};
		
		["bounceback"] = {
			title = "Bounceback",
			description = "15x Ability Knockback",
		},
	}
}
return perkData