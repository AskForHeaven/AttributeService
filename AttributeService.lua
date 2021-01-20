local RunService = game:GetService("RunService")
local AttributeService = {}

type Dictionary = {[string]: any}
type Array = {[number]: any}

function AttributeService:SetAttributes(instance: Instance,attributes: Dictionary)
	for key,value in pairs(attributes) do
		instance:SetAttribute(key,value)
	end
end

function AttributeService:SetGroupAttribute(group: Array,key: string,value)
	for _,instance in pairs(group) do
		instance:SetAttribute(key,value)
	end
end

function AttributeService:SetGroupAttributes(group: Array, attributes: Dictionary)
	for _,instance in pairs(group) do
		AttributeService:SetAttributes(instance,attributes)
	end
end

function AttributeService:GetChildrenWithAttribute(parent: Instance,attribute: string)
	local children = {}
	for _,child in pairs(parent:GetChildren()) do
		if child:GetAttribute(attribute) ~= nil then
			table.insert(children,child)
		end
	end
	return children
end

function AttributeService:ClearAllAttributes(instance: Instance)
	for key,value in pairs(instance:GetAttributes()) do
		instance:SetAttribute(key,nil)
	end
end

function AttributeService:GroupClearAllAttributes(group: Array)
	for _,instance in pairs(group) do
		AttributeService:ClearAllAttributes(instance)
	end
end

function AttributeService:FindFirstChildWithAttribute(parent: Instance,attribute: string,recursive: boolean)
	function Search(parent)
		for _,child in pairs(parent:GetChildren()) do
			print(child)
			if child:GetAttribute(attribute) ~= nil then
				return child
			else
				Search(child)
			end
		end
	end
	
	return Search(parent)
end

function AttributeService:WaitForChildWithAttribute(parent: Instance,attribute: string,timeOut: number)
	local start = os.time()
	local defaultWarn = 2
	while not timeOut or os.time() < start + timeOut do
		if defaultWarn and os.time() < start + defaultWarn then
			warn("Infinite yield possible on "..parent:GetFullName()..":WaitForChildWithAttribute")
			defaultWarn = nil	
		end
		for _,child in pairs(parent:GetChildren()) do
			if child:GetAttribute(attribute) ~= nil then
				return child
			end	
		end
		RunService.Heartbeat:Wait()
	end
end

return AttributeService