-- kyle emmerich

local terrainUtil = {}

local VOXEL_SIZE = Vector3.new(4, 4, 4)
local TERRAIN = workspace.Terrain

function terrainUtil.getTerrainAt(pos)
    local cellPos = TERRAIN:WorldToCell(pos)
    local regionCorner = TERRAIN:CellCornerToWorld(cellPos)
    local region = Region3.new(regionCorner, regionCorner + VOXEL_SIZE)
    local material, occupancy = TERRAIN:ReadVoxels(region, 4)
    return material[1][1][1], occupancy[1][1][1]
end

local WATER = Enum.Material.Water
local AIR = Enum.Material.Air


function terrainUtil.isPointUnderwater(point)
    local cellPos = TERRAIN:WorldToCell(point)
    local regionCorner = TERRAIN:CellCornerToWorld(cellPos.X, cellPos.Y, cellPos.Z)
    local region = Region3.new(regionCorner, regionCorner + Vector3.new(4, 8, 4))
    local material, occupancy = TERRAIN:ReadVoxels(region, 4)
    
    local material0, occupancy0 = material[1][1][1], occupancy[1][1][1] -- cell containing point
    local material1, occupancy1 = material[1][2][1], occupancy[1][2][1] -- cell above
    
    if material0 == WATER then
        -- point is in water cell and cell above is not air => we're either completely in water or at the water-solid boundary
        -- so we can safely assume underwater
        if material1 ~= AIR then
            -- Can overestimate water level to be at top of cell
            return true, cellPos.Y * VOXEL_SIZE.Y, false
        end
    
        -- cell above is air => have to estimate the plane based on occupancy
        local waterHeightCell = occupancy0
        -- cell clamping from mesher
        local waterLevelCell = cellPos.Y + 0.5 + math.max(0, waterHeightCell - 0.5)
        return point.Y / 4 < waterLevelCell, waterLevelCell * VOXEL_SIZE.Y, true
    elseif material1 == WATER then
        -- point is in solid cell and cell above is water => we're at the water-solid boundary
        -- so we can safely assume underwater
        if material0 ~= AIR then
            -- Can overestimate water level to be at top of cell
            -- Adding plus 2 because cell0 is already + 1 above posY
            return true, (cellPos.Y + 1) * VOXEL_SIZE.Y, false
        end
    
        -- point is in air => have to estimate the plane based on occupancy
        local waterHeightCell = occupancy1
        -- cell clamping from mesher
        local waterLevelCell = (cellPos.Y + 1) - math.min(waterHeightCell, 0.5)
        return point.Y / 4 > waterLevelCell, waterLevelCell * VOXEL_SIZE.Y, true
    end
    return false, 0, false
end

    
return terrainUtil