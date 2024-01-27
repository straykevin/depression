local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
return {

    GetFilter = function(self)
        local overlapParams = OverlapParams.new()
        overlapParams.FilterDescendantsInstances = {self._Instance}
        overlapParams.FilterType = Enum.RaycastFilterType.Exclude

        return overlapParams
    end,

    Init = function(self)
        self.state = {

            _ActivateCount = 0

        }
    end,

    Activate = function(self)
        self.state._ActivateCount += 1
        if self.state._ActivateCount ~= 1 then return end
        self:Lock()

        local gates = CollectionService:GetTagged("Gates-Intro")

        for _, gate in pairs(gates) do

            local tween = TweenService:Create(gate, TweenInfo.new(2.5, Enum.EasingStyle.Exponential), {CFrame = gate.CFrame:ToWorldSpace(CFrame.new(0, -gate.Size.Y + .1, 0))})
            
            tween:Play()
        end

    
    end,

    Deactivate = function(self)
        print("Deactivated: ", self._Instance)
    end,
}