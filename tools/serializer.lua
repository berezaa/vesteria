-- Command line code to serialize assets for rojo syncing

local feed = "return {\n"

local defaults = {
    ["Volume"] = 0.5,
    ["EmitterSize"] = 10,
    ["MaxDistance"] = 10000,
    ["Looped"] = false,
    ["PlaybackSpeed"] = 1,
}

for _, sound in pairs(game.ReplicatedStorage.assets.sounds:GetChildren()) do
    feed = feed .. "\t[\"" .. sound.Name .. "\"] = {\n"
    for property, default in pairs(defaults) do
        local value = sound[property]
        if value ~= default then
            if typeof(value) == "number" then
                value = (math.floor(value * 10)) / 10
            end
            feed = feed .. "\t\t" .. property .. " = " .. tostring(value) .. ",\n"
        end
    end
	feed = feed .. "\t\tSoundId = \"" .. sound.SoundId .. "\",\n"
	feed = feed .. "\t},\n"
end

feed = feed .. "}"
workspace.stuff.Source = feed