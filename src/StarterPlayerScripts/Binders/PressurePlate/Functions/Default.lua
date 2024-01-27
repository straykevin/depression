return {

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