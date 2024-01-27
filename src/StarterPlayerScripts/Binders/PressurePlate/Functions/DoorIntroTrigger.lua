local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
return {
    Init = function(self)
        self.state = {

            _ActivateCount = 0

        }
    end,

    Activate = function(self)
        self.state._ActivateCount += 1
        if self.state._ActivateCount ~= 1 then return end
    
        local door: Part = CollectionService:GetTagged("Door-Intro")[1]

        local tween = TweenService:Create(door, TweenInfo.new(2.5, Enum.EasingStyle.Exponential), {CFrame = door.CFrame:ToWorldSpace(CFrame.new(0, -door.Size.Y + .1, 0))})
        
        tween:Play()
    
    end,

    Deactivate = function(self)
        print("Deactivated: ", self._Instance)
    end,
}