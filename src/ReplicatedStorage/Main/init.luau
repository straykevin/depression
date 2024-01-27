local ReplicatedStorage = game:GetService("ReplicatedStorage")
--[[
    Authors: straykevin
]]--


--[[ Start of Dependencies ]]--

local Binder = require(ReplicatedStorage:WaitForChild("Packages").Binder)


--[[ End of Dependencies ]]--

--[=[
    @class Main

    The loader for the gamejam.

]=]
local Main = {
    Binders = {}
}


--[=[
    The source of the game's single script artitechture. 

]=]
function Main.init(source)
    --[[ Start of Binder Init ]]--
    for _, module in pairs(source.Parent.Binders:GetChildren()) do
        local config = {
            TagName = module.Name,
            Ancestors = {workspace}
        }

        local newBinder = Binder.new(config, require(module))
        newBinder:Start()

        Main.Binders[module.Name] = newBinder
    end
    

    --[[ End of Binder Init ]]--

    return Main
end


return Main