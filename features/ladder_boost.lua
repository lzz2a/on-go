
return function(settings)
    local players = game:GetService("Players");
    local collisionGroup = include("classes/collisiongroup").new();

    local function createCloneHead(targetCharacter)
        local head = targetCharacter:FindFirstChild("Head");
        local clonedHead = targetCharacter:FindFirstChild("cloneHead") 
    
        if head and not clonedHead then
            clonedHead = head:Clone();
            clonedHead.Name = "cloneHead";
            clonedHead.Parent = targetCharacter;
            clonedHead.Size = Vector3.new(5, 5, 5);
            clonedHead.Transparency = 1;
            clonedHead.CFrame = head.CFrame;
            clonedHead.CanCollide = true;
    
            for i,v in pairs(clonedHead:GetChildren()) do
                if not v:IsA("SpecialMesh") then
                    v:Destroy(); -- rid of decals and stuff
                end
            end
    
            local weld = Instance.new("Weld", clonedHead) do
                weld.Part0 = head;
                weld.Part1 = clonedHead;
    
                weld.C0 = CFrame.new()
                weld.C1 = head.CFrame:toObjectSpace(clonedHead.CFrame);
            end
    
            collisionGroup:AddPart(clonedHead)
            collisionGroup:AddPart(head);
        end
    
        return clonedHead
    end
    
    local function raycast(origin, direction, type ,blacklist)
        local raycastParams = RaycastParams.new(); do
            raycastParams.FilterType = type
            raycastParams.FilterDescendantsInstances = blacklist or {};
        end
    
        return workspace:Raycast(origin, direction, raycastParams);
    end
    
    local function getLandingPart(targetCloneHead)
        local character = players.LocalPlayer.Character;
        local rootPart = character and character:WaitForChild("HumanoidRootPart");
        
        local result = raycast(rootPart.Position, Vector3.new(0, -5, 0), Enum.RaycastFilterType.Include, {targetCloneHead});
        
        if result then
            return true;
        end
    end
    
    local function getCurrentY()
        local character = players.LocalPlayer.Character;
        local head = character and character:WaitForChild("Head");
    
        if head then
            return head.Position.Y;
        end
    
        return 0
    end
    
    local function castBoost(character)
        local head = character:FindFirstChild("Head");
        local clonedHead = createCloneHead(character);
    
        head.CanCollide = false;
        clonedHead.Size = Vector3.new(settings.PHYSICS.LADDER.SIZE, settings.PHYSICS.LADDER.SIZE, settings.PHYSICS.LADDER.SIZE); 

        if not settings.PHYSICS.LADDER.ENABLED then
            clonedHead.CanCollide = false;
            clonedHead.Transparency = 1;
            return;
        end

        if getLandingPart(clonedHead) then
            clonedHead.CanCollide = true;
        else
            clonedHead.CanCollide = false
        end
    end
    
    game:GetService("RunService").RenderStepped:Connect(function()
        for _, plr in pairs(players:GetPlayers()) do
            if plr.Character and not (plr == players.LocalPlayer) then
                castBoost(plr.Character)
            end
        end
    end)
end
