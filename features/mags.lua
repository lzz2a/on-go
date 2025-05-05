
-- might switch to a class so we cn access data but idk what we would need it for ff
return function(settings)
    local state = "catch"; 
    local using = false;

    local function getDistance()
        return state == "catch" and settings.BALL.CATCHING.DISTANCE or settings.BALL.SWATTING.DISTANCE;
    end   

    local function magStatusGood()
        local replicatedStorage = game:GetService("ReplicatedStorage");
        local values = replicatedStorage:FindFirstChild("Flags");

        if values then
            local fumbleValue = values:FindFirstChild("Fumble");
            local statusValue = values:FindFirstChild("Status");

            if fumbleValue and statusValue then
                return fumbleValue.Value == false and statusValue.Value == "InPlay";
            end
        end

        return true; -- Probably practice game?
    end

    local function glue(football, maxDistance)
        local client = game:GetService("Players").LocalPlayer;
        local character = client.Character;

        if character then            
            local leftArm = character:FindFirstChild("CatchLeft");
            local rightArm = character:FindFirstChild("CatchRight");
            
            if not leftArm or not rightArm then
                return;
            end
            
            local leftArmDistance = (leftArm.Position - football.Position).Magnitude;
            local rightArmDistance = (rightArm.Position - football.Position).Magnitude;
            local closestArm = leftArmDistance < rightArmDistance and leftArm or rightArm;

            if not magStatusGood() then
                return;
            end 
            
            local starting = tick();
            local connections = {};

            local function terminate()
                for _, connection in pairs(connections) do
                    connection:Disconnect()
                end

                table.clear(connections);
                using = false;
            end

            local function update()
                if (tick() - starting) > 5 then
                    terminate();
                    return;
                end

                if not magStatusGood() then
                    terminate();
                    return;
                end

                if (football.Position - closestArm.Position).Magnitude > maxDistance then
                    terminate();
                    return;
                end

                if football and football.Parent then
                    firetouchinterest(closestArm, football, 0);
                    task.wait()
                    firetouchinterest(closestArm, football, 1);
                else
                    terminate();
                    return;
                end
            end

            for i = 1, 4 do
                table.insert(connections, game:GetService("RunService").RenderStepped:Connect(update));
            end

            using = true;
        end
    end

    game:GetService("RunService").RenderStepped:Connect(function()
        local client = game:GetService("Players").LocalPlayer;
        local character = client.Character;
        local root = character and character.PrimaryPart;

        if root then 
            local closestDistance = math.huge;
            local closestBall = nil;

            for _, part in pairs(workspace:GetChildren()) do
                if not (part.Name == "Football") or not part:IsA("BasePart") then
                    continue;
                end

                local distance = (root.Position - part.Position).Magnitude or 0;
        
                if distance < closestDistance and distance < getDistance() then
                    closestBall = part; 
                    closestDistance = distance; 
                end     
            end
        
            if closestBall then glue(closestBall, getDistance()) end 
        end
    end)

    local old; old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local args = {...};
    
        if (args[2] == "swat" or args[2] == "catch" or args[2] == "catch ") and string.lower(getnamecallmethod()) == "fireserver" then
            state = args[2] == "swat" and args[2] or "catch";
        end
    
        return old(self, ...);
    end))    
end