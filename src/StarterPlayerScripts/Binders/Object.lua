-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Folders
local ObjectsFolder = ReplicatedStorage:WaitForChild("ObjectsFolder")

-- Constants 
local MAX_INTERACTION_DISTANCE = 10

local object = {}
object.__index = object

-- Creates a new object that can be manipulated
function object.new(objectName : string, location : CFrame)
    local self = setmetatable({}, object)

    if objectName and location then
        self.object = ObjectsFolder[objectName]:Clone()
        self.object.CFrame = location

        self.name = objectName
        self.playerHolding = false
        self.isHoldable = false --Some items are holdable, others are not
        self.isInteractable = false --After it has been interacted with we can toggle it no longer interactable
    end

    --Pickup function
    function self:pickup(player : Player)
        if self.isHoldable and self:canInteract(player) then
            self.playerHolding = true
            self.isInteractable = false
        end
    end

    function self:interact(player : Player)
        if self.canInteract(player) then
            self.isInteractable = false
            
            --Trigger something in the Interaction Module
        end
    end

    --Drop function
    function self:drop(objectName : string, location : Vector3)
        if self.playerHolding and self.object == nil then
            self.playerHolding = false
            self.isInteractable = true
        end
    end

    --Function to check interaction distance
    function self:canInteract(player : Player)
        if self.isHoldable == false or self.isInteractable == false then return false end

        local playerPosition = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position
        
        if playerPosition and (self.object.Position - playerPosition).magnitude < MAX_INTERACTION_DISTANCE then
            return true
        end

        return false
    end

    return self
end

return object