--Services
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local LightingModule = {}

--Presets for lighting (Name each the actual attribute that you'd like to update)
local levelSettings = {
    [1] = {Ambient = Color3.new(), Brightness = Color3.new(), EnvironmentDiffusion = 1}
}

--Updates the bloom
function LightingModule.setBloom(threshold : number, speed : number)
    TweenService:Create(game.Lighting.Bloom, TweenInfo.new(speed), {Threshold = threshold}):Play()
end

--Updates the lighting to one of the presets
function LightingModule.updateZoneLighting(presetNum : number)
    for key, value in pairs(levelSettings[presetNum]) do
        Lighting[key] = value
    end
end

