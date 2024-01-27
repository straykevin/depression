local Players = game:GetService("Players")


local player = Players.LocalPlayer

return {

    GetFilter = function(self)
        local overlapParams = OverlapParams.new()
        overlapParams.FilterDescendantsInstances = {self._Instance, player.Character}
        overlapParams.FilterType = Enum.RaycastFilterType.Exclude

        return overlapParams
    end,

    Init = function(self)
        self.state = {}
    end,

    Activate = function(self)
        print("Activated: ", self._Instance)
    end,

    Deactivate = function(self)
        print("Deactivated: ", self._Instance)
    end,

}