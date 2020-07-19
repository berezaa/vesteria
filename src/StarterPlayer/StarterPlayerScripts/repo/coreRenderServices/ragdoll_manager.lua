local ragdoll_manager = {}

local replicatedStorage = game:GetService("ReplicatedStorage")

local modules		= require(replicatedStorage:WaitForChild("modules"))
local physics 		= modules.load("physics")

function ragdoll_manager.ragDollCharacter(entity, renderEntityData)
    local ragdoll = entity:Clone()
    ragdoll.Parent = entity.Parent
    entity:Destroy()
    local motorNames = {"Root", "Neck", "RightShoulder", "LeftShoulder", "RightElbow", "LeftElbow", "Waist", "RightWrist", "LeftWrist", "RightHip", "LeftHip", "RightKnee", "LeftKnee", "RightAnkle", "LeftAnkle"}
    for _, motorName in pairs(motorNames) do
        ragdoll:FindFirstChild(motorName, true):Destroy()
    end

    local rigAttachmentPairsByName = {}
    for _, desc in pairs(ragdoll:GetDescendants()) do
        if desc:IsA("Attachment") and desc.Name:find("RigAttachment") and (not desc.Name:find("Root")) then
            local name = desc.Name
            if not rigAttachmentPairsByName[name] then
                rigAttachmentPairsByName[name] = {}
            end
            table.insert(rigAttachmentPairsByName[name], desc)
        end
    end

    physics:setWholeCollisionGroup(ragdoll, "passthrough")

    local constraints = Instance.new("Folder")
    constraints.Name = "constraints"
    constraints.Parent = ragdoll

    for name, pair in pairs(rigAttachmentPairsByName) do
        local constraint = Instance.new("BallSocketConstraint")
        constraint.LimitsEnabled = true
        constraint.TwistLimitsEnabled = true
        constraint.Attachment0 = pair[1]
        constraint.Attachment1 = pair[2]
        constraint.Parent = constraints

        pair[1].Parent.CanCollide = true
        pair[2].Parent.CanCollide = true
    end

    local hitbox = renderEntityData.entityContainer:FindFirstChild("hitbox")
    if hitbox then
        local bp = Instance.new("BodyPosition")
        bp.MaxForce = Vector3.new(1e6, 0, 1e6)
        bp.Parent = ragdoll.LowerTorso

        local connection
        local function onHeartbeat()
            if not bp.Parent then
                connection:Disconnect()
                return
            end
            bp.Position = hitbox.Position
        end
        connection = game:GetService("RunService").Heartbeat:Connect(onHeartbeat)
    end

end

return ragdoll_manager