local module = {}

local network
local mapping
local manager_item


-- let the player be authoritative in this regard, it's their personal data anyway.
local function onRegisterHotbarSlotData(player, dataType, id, position)

    local playerData = network:invoke("getPlayerData", player)
    if not playerData then return end

    local hotbarData = playerData.hotbar
    local result

    local function clearPlayerDataByView(pos, view)
        local changed

    end

    local function clearHotbarData(pos)
        for i, hotbarSlotData in pairs(hotbarData) do
            if hotbarSlotData.position == pos then
                -- search & destroy
                if hotbarSlotData.dataType == mapping.dataType.equipment then

                end
                table.remove(hotbarData, i)
                result = true
            end
        end
    end

	if not id or not dataType then
		if position then
            clearHotbarData(position)
		end
	elseif position then
		-- clear out the position for this one
        clearHotbarData(position)

        if dataType == mapping.dataType.equipment then
            -- i'm so sorry (id is a table of equipmentData)
            local equipmentSlotData = id
            local itemLocationView = equipmentSlotData.itemLocationView

            local trueEquipmentSlot, trueEquipmentSlotData = manager_item.getTrueItemSlotData(playerData, equipmentSlotData, itemLocationView)
            -- attach the hotbar information to the real item
            if trueEquipmentSlotData then
                assert((itemLocationView == "inventory" or itemLocationView == "equipment"), "invalid item location view")
                -- todo: consolidate this init somewhere
                trueEquipmentSlotData.userData = trueEquipmentSlotData.userData or {}
                trueEquipmentSlotData.userData.hotbarSlot = position
                -- this seems scary but I'm sure its fine
                playerData[itemLocationView][trueEquipmentSlot] = trueEquipmentSlotData
                playerData.nonSerializeData.setPlayerData(itemLocationView, playerData[itemLocationView])
            end
        else
            table.insert(hotbarData, {dataType = dataType; id = id; position = position})
        end

		-- update the inventory
        result = true
    end
    if result then
        playerData.nonSerializeData.setPlayerData("hotbar", hotbarData)
    end
    return result
end

function module.init(Modules)
    network = Modules.network
    mapping = Modules.mapping
    manager_item = Modules.manager_item
	network:create("playerRequest_getHotbarSlotData", "RemoteFunction", "OnServerInvoke", onRegisterHotbarSlotData)
end

return module