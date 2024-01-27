local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Gizmos = require(ReplicatedStorage.Modules.Gizmos)


local PressurePlate = {}
PressurePlate.__index = PressurePlate

function PressurePlate.new(instance: Model)
    local self = setmetatable({}, PressurePlate)
    print(instance, "Initiated!")
    
    local functionID = instance:GetAttribute("FunctionID")
    
    if functionID then
        self._Functions = require(script.Functions[functionID])
    else
        self._Functions = require(script.Functions["Default"])
        warn(instance, " does not have an accompanied FunctionID. Setting it to the default.")
    end

    if self._Functions["Init"] then
        self._Functions.Init(self)
    end


    self._IsActive = false

    local primPart = instance.PrimaryPart
    local origin = primPart.CFrame
    local offsetCFrame = CFrame.new(0, -primPart.Size.Y * .80, 0)
    local offsetSize = Vector3.new(0, .25, 0)

    self._Instance = instance
    self._PrimPart = primPart
    self._Origin = origin
    self._PressedCFrame = primPart.CFrame:ToWorldSpace(offsetCFrame)


    self._DetectionSize = primPart.Size + offsetSize
    self._DetectionCFrame = primPart.CFrame:ToWorldSpace(CFrame.new(offsetSize/2))

    local startCFrame: CFrame = nil

    local timeBeforeDeactivate = tonumber(instance:GetAttribute("DeactivationTime")) or 1.5 -- how long before an object should be deactivated
    local currTime = 0 -- current time

    if instance:GetAttribute("Visualize") then
        Gizmos.onDraw:Connect(function(g)
    
            g.setTransparency(0.5)
            g.setColor(Color3.new(1, 0, 0))
            g.drawBox(self._DetectionCFrame, self._DetectionSize)
        end)
    end


    RunService.Heartbeat:Connect(function(dt)
        
        self._DetectionCFrame = primPart.CFrame:ToWorldSpace(CFrame.new(offsetSize/2))

        -- offseting cframe height to account for increase in size... (we don't want to detect the lowerbounds, only the higherbounds)
        local query = workspace:GetPartBoundsInBox(self._DetectionCFrame, self._DetectionSize, self._Functions.GetFilter(self) or require(script.Functions["Default"].GetFilter(self)))
        
        --[[ 
            
            The query works as the following. We use the query to decide whether or not an object is colliding...
            When no object is detected touching a pressure plate, then we begin a countdown to deactivation...

        ]]--


        if #query > 0 then
            startCFrame = nil
            currTime = 0
            self:_Toggle(true) -- in the case that the object's cframe
            self:Activate()
        else 
            if currTime >= timeBeforeDeactivate then
                self:Deactivate()

            else
                currTime += dt

                -- give it some time before we start lerping...
  

                if not startCFrame then  -- hasn't started the lerp yet since last activation...
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

    warn("Activated Function!?")
    self._Functions.Activate(self)
    

end

function PressurePlate:Deactivate()
    if not self._IsActive then return end
    self._IsActive = false
    self:_Toggle(false)

    self._Functions.Deactivate(self)

end


return PressurePlate