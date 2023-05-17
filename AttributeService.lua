local RunService = game:GetService("RunService")
local AttributeService = {}

local DEFAULT_TIMEOUT = 2

type Dictionary = {[string]: any}
type Array = {[number]: any}

function AttributeService:SetAttributes(instance: Instance, attributes: Dictionary)
	for key, value in attributes do
		instance:SetAttribute(key, value)
	end
end

function AttributeService:SetGroupAttribute(group: Array, key: string, value: any)
	for _, instance in group do
		instance:SetAttribute(key, value)
	end
end

function AttributeService:SetGroupAttributes(group: Array, attributes: Dictionary)
	for _, instance in group do
		AttributeService:SetAttributes(instance, attributes)
	end
end

function AttributeService:GetChildrenWithAttribute(parent: Instance, attribute: string)
	local children = {}
	
	for _,child in pairs(parent:GetChildren()) do
		if child:GetAttribute(attribute) ~= nil then
			table.insert(children,child)
		end
	end
	
	return children
end

function AttributeService:ClearAllAttributes(instance: Instance)
	for key, value in instance:GetAttributes() do
		instance:SetAttribute(key, nil)
	end
end

function AttributeService:GroupClearAllAttributes(group: Array)
	for _,instance in group do
		AttributeService:ClearAllAttributes(instance)
	end
end

function AttributeService:FindFirstChildWithAttribute(parent: Instance, attribute: string, recursive: boolean)
	local function Search(parent)
		for _, child in parent:GetChildren() do
			if child:GetAttribute(attribute) == nil then
				if not recursive then
					continue
				end
				
				Search(child)
				continue
			end
			
			return child
		end
	end

	return Search(parent)
end

function AttributeService:WaitForChildWithAttribute(parent: Instance,attribute: string,timeOut: number)
	local hasBeenWarned = false	
	local start = os.time()
	
	while not timeOut or os.time() < start + timeOut do
		if not hasBeenWarned and os.time() < start + DEFAULT_TIMEOUT then
			warn("Infinite yield possible on WaitForChildWithAttribute for " . .parent:GetFullName())
			hasBeenWarned = true
		end
		
		for _, child in parent:GetChildren() do
			if child:GetAttribute(attribute) == nil then
				continue
			end
			
			return child
		end
		
		RunService.Heartbeat:Wait()
	end
end

return AttributeService
