local RunService = game:GetService("RunService")
local PressurePlate = {}
PressurePlate.__index = PressurePlate

function PressurePlate.new(instance: Model)
    local self = setmetatable({}, PressurePlate)
    print(instance, "Initiated!")
    
    local functionID = instance:GetAttribute("FunctionID")
    
    if functionID then
        self._Function = require(script.Functions[functionID])
    else
        self._Function = require(script.Functions["Default"])
        warn(instance, " does not have an accompanied FunctionID. Setting it to the default.")
    end

    if self._Function["Init"] then
        self._Function.Init(self)
    end


    self._IsActive = false

    local primPart = instance.PrimaryPart
    local origin = primPart.CFrame

    self._Instance = instance
    self._PrimPart = primPart
    self._Origin = origin
    self._PressedCFrame = primPart.CFrame:ToWorldSpace(CFrame.new(0, -primPart.Size.Y * .80, 0))

    local startCFrame: CFrame = nil

    local timeBeforeDeactivate = tonumber(instance:GetAttribute("DeactivationTime")) or 1 -- how long before an object should be deactivated
    local currTime = 0 -- current time

    RunService.Heartbeat:Connect(function(dt)
    
        local overlapParams = OverlapParams.new()
        overlapParams.FilterDescendantsInstances = {instance}
        overlapParams.FilterType = Enum.RaycastFilterType.Exclude


        local query = workspace:GetPartBoundsInBox(primPart.CFrame, primPart.Size + Vector3.new(.1, .1, .1), overlapParams)
        
        --[[ 
            
            The query works as the following. We use the query to decide whether or not an object is colliding...
            When no object is detected touching a pressure plate, then we begin a countdown to deactivation...

        ]]--

        if #query > 1 then
            startCFrame = nil
            currTime = 0
            self:_Toggle(true) -- in the case that the object's cframe
            self:Activate()
        else 
            if currTime >= timeBeforeDeactivate then
                self:Deactivate()

            else
                currTime += dt

                -- hasn't started the lerp yet since last activation...
                if not startCFrame then
                    startCFrame = primPart.CFrame
                end

                primPart.CFrame = startCFrame:Lerp(origin, math.clamp(currTime/timeBeforeDeactivate, 0, 1))
                
            end
        end
    end)

    return self
end

function PressurePlate:_Toggle(bool)
    local primPart = self._PrimPart
    if bool then
        primPart.CFrame = self._PressedCFrame
    else
        primPart.CFrame = self._Origin
    end

end

function PressurePlate:Activate()
    if self._IsActive then return end
    self._IsActive = true
    self:_Toggle(true)

    self._Function.Activate(self)
    

end

function PressurePlate:Deactivate()
    if not self._IsActive then return end
    self._IsActive = false
    self:_Toggle(false)

    self._Function.Deactivate(self)

end


return PressurePlate