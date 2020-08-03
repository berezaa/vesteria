local module = {}

local TeleportService = game:GetService("TeleportService")

local teleportData = TeleportService:GetLocalPlayerTeleportData() or {}

local arrivingFrom = teleportData.arrivingFrom
local providedTimeStamp = teleportData.dataTimestamp
local accessoriesData = teleportData.playerAccessories

function module.init(Modules)
    local network = Modules.network

    local slot, accessories

    if arrivingFrom then
        -- todo: blackout UI
        slot = TeleportService:GetTeleportSetting("dataSlot")
        if accessoriesData and type(accessoriesData) == "string" then
            accessories = game:GetService("HttpService"):JSONDecode(accessoriesData)
        end
    else
        slot = 1
    end
    network:invokeServer("loadPlayerData", slot, providedTimeStamp, accessories)
end

return module