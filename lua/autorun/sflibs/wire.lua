
local wire_module = {}

local function arrcpy(arr)
	local arr2 = {}
	for _,d in ipairs(arr) do
		arr2[d] = true
	end
	return arr2
end

-- TODO: Add types argument
function wire_module.setPorts(inputs, outputs)
	if inputs == nil then inputs = {} end
	if outputs == nil then outputs = {} end
	
	for _,name in ipairs(inputs) do
		if type(name) ~= "string" then error("Invalid argument in name",0) end
	end
	
	for _,name in ipairs(outputs) do
		if type(name) ~= "string" then error("Invalid argument in name",0) end
	end
	
	SF_Compiler.currentChip.data.inputs = arrcpy(inputs)
	SF_Compiler.currentChip.data.outputs = arrcpy(outputs)
	SF_Compiler.currentChip.data.inputVals = {}
	
	WireLib.AdjustSpecialInputs(SF_Compiler.currentChip.ent,inputs)
	WireLib.AdjustSpecialOutputs(SF_Compiler.currentChip.ent,outputs)
end

function wire_module.getInput(name)
	if name == nil or type(name) ~= "string" then return nil end
	return SF_Compiler.currentChip.data.inputVals[name]
end

function wire_module.setOutput(name, value)
	if name == nil or type(name) ~= "string" or not SF_Compiler.currentChip.data.outputs[name] then return end
	if type(value) ~= "number" then return end
	Wire_TriggerOutput(SF_Compiler.currentChip.ent, name, value)
end

SF_Compiler.AddModule("wire",wire_module)