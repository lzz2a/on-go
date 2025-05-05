local PartData = {};
PartData.__index = PartData;

function PartData.new(part)
	return setmetatable({Part = part, Constraints = {}, Connections = {}}, PartData)
end

local CollisionGroup = {};
CollisionGroup.__index = CollisionGroup;

function CollisionGroup.new()
	local self = setmetatable({}, CollisionGroup); do
		self._parts ={};
		self._enabled = true;
	end
	
	return self;
end

function CollisionGroup:_addConstraint(part0, part1)
	local constraint = Instance.new("NoCollisionConstraint", part0); do
		constraint.Part0 = part0;
		constraint.Part1 = part1;
		
		constraint.Enabled = self._enabled;
		constraint.Parent = workspace;
	end
	
	return constraint;
end

function CollisionGroup:_partAlreadyAdded(part)
	local checked = false;
	
	for _, partData in pairs(self._parts) do
		if partData.Part == part then
			checked = true;
			break;
		end
	end
	
	return checked;
end

function CollisionGroup:AddPart(part)
	if typeof(part) == "Instance" and part:IsA("BasePart") and not self:_partAlreadyAdded(part) then
		local select = #self._parts + 1;
		
		self._parts[select] = PartData.new(part);
		for _, partData in pairs(self._parts) do
			if partData.Part == part then
				continue;
			end
			
			local constraint = self:_addConstraint(part, partData.Part);
			
			table.insert(partData.Constraints, constraint);
			table.insert(self._parts[select].Constraints, constraint)
		end
	end
end

function CollisionGroup:SetEnabled(status)
	self._enabled = status;
	
	for _, partData in pairs(self._parts) do
		for _, constraint in pairs(partData.Constraints) do
			constraint.Enabled = self._enabled;
		end
	end
end

return CollisionGroup;