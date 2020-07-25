local module = {}
	module.equipmentPosition = {}
		module.equipmentPosition.weapon = 1
		module.equipmentPosition.head = 2

		-- unused --
		module.equipmentPosition.body = 3
		module.equipmentPosition["left arm"] = 4
		module.equipmentPosition["right arm"] = 5
		module.equipmentPosition["left leg"] = 6
		module.equipmentPosition["right leg"] = 7
		-- /unused --

		module.equipmentPosition["upper"] = 8
		module.equipmentPosition["lower"] = 9

		module.equipmentPosition["pet"] = 10

		module.equipmentPosition["offhand"] = 11

		module.equipmentPosition["arrow"] = 12

	module.dataType = {}
		module.dataType.item = 1
		module.dataType.ability = 2
		module.dataType.abilitySlot = 3

	module.gripType = {}
		module.gripType.right = 1
		module.gripType.left = 2
		module.gripType.both = 2

	module.equipmentHairType = {}
		module.equipmentHairType.all = 1
		module.equipmentHairType.partial = 2
		module.equipmentHairType.none = 3

	module.accountBanState = {}
		module.accountBanState.warned = 1
		module.accountBanState.day1 = 2
		module.accountBanState.day3 = 3
		module.accountBanState.day7 = 4
		module.accountBanState.permanent = 5

	module.questState = {}
		module.questState.accepted = 1
		module.questState.active = 2
		module.questState.completed = 3
		module.questState.cooldown = 4
		module.questState.insufficient = 5
		module.questState.denied = 6
		module.questState.handing = 7
		module.questState.unassigned = 8
		module.questState.objectiveDone = 9


	--hat, skin, undershirt, underwear, eyebrow
	module.accessoryType = {}
		module.accessoryType.hair = 1
		module.accessoryType.skin = 2
		module.accessoryType.eyebrow = 3
		module.accessoryType.undershirt = 4
		module.accessoryType.underwear = 5

function module.getMappingByValue(mapSection, value)
	for i, v in pairs(module[mapSection]) do
		if v == value then
			return i
		end
	end

	return nil
end

return module