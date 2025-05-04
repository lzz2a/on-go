return function(constructor)
    local physicsTab = constructor._window:AddTab("Physics");
    local ladderBox = physicsTab:AddLeftGroupbox("Ladder")
      
    local ladderToggle = ladderBox:AddToggle("CatchEnabled", {
        Text = "Enabled",
        Default = constructor.Settings.PHYSICS.LADDER.ENABLED;
        Callback = function(value)
            constructor.Settings.PHYSICS.LADDER.ENABLED = value;
        end
    });
    
    ladderToggle:AddKeyPicker("LadderKeybind", {
        Default = "H",
        Mode = "Toggle",
        SyncToggleState = true
    })
end