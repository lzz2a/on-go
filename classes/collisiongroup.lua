local CollisionGroup = {};
CollisionGroup.__index = CollisionGroup;

function CollisionGroup.new()
    return setmetatable({_objects = {}, _enabled = true}, CollisionGroup);
end

function CollisionGroup:_addNoCollisionConstraint(part0, part1)
    local constraint = Instance.new("NoCollisionConstraint", part0); do
        constraint.Part0 = part0;
        constraint.Part1 = part1;
        
        constraint.Enabled = self._enabled;
        constraint.Parent = workspace;
    end

    return constraint;
end

function CollisionGroup:_checkObject(part)
    local inObjects = false;

    for _, objectData in pairs(self._objects) do
        if objectData.Part == part then 
            inObjects = true;
            break;
        end
    end

    return inObjects;
end

function CollisionGroup:AddObject(object)
    if typeof(object) == "Instance" and object:IsA("Part") and not self:_checkObject(object) then
        local select = #self._objects + 1;
        self._objects[select] = {Part = object, Constraints = {}, Connections = {}};

        for _, objectData in pairs(self._objects) do
            if not (objectData.Part == object) then
                local constraint = self:_addNoCollisionConstraint(object, objectData.Part); do
                    table.insert(objectData.Constraints, Constraint);
                end

                table.insert(self._objects[select].Constraints, constraint);            
            end
        end
    end
end

function CollisionGroup:RemoveObject(object)
    if typeof(object) == "Instance" and object:IsA("BasePart") then
        local select = nil 

        for i, objectData in pairs(self._objects) do
            for _, constraint in pairs(objectData.Constraints) do
                if typeof(Constraint) == "Instance" and Constraint:IsA("NoCollisionConstraint") then
                    Constraint:Destroy();
                end
            end

            if (objectData.Part == object) then
                select = i;
            end
        end

        if select then
            table.remove(self._objects, select);
        end
    end
end

function CollisionGroup:SetEnabled(status)
    self._enabled = status;

    for _, objectData in pairs(self._objects) do 
        for _, constraint in pairs(objectData.Constraints) do
            constraint.Enabled = status;
        end
    end
end

return CollisionGroup;