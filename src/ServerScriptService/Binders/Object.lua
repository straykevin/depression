-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Folders


-- Constants 
local MAX_INTERACTION_DISTANCE = 10

local object = {}
object.__index = object



-- Creates a new object that can be manipulated. 
-- WARNING: Make sure models are set to the atomic streaming state.
function object.new(instance: Model)
    local self = setmetatable({}, object)
    print("Initiated Object: ", instance)

    instance:SetAttribute("isInteractable", true)
    self.object = instance


    local function onPlayerAdded(player)
        instance.PrimaryPart:SetNetworkOwner(player)
    end

    for _, player in pairs(Players:GetPlayers()) do
        onPlayerAdded(player)
    end

    Players.PlayerAdded:Connect(onPlayerAdded)




    return self
end

return object