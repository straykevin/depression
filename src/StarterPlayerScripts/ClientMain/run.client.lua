local main = require(script.Parent)


--[[ Example ]]--
task.wait(1.5) -- need to wait for instances to load under workspace... (since this script runs before all models are able to load)
warn(main["Binders"].Object:GetAll())