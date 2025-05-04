return function(constructor)
    local ballTab = constructor._window:AddTab("Ball");
    local catchBox, swatBox = ballTab:AddLeftGroupbox("Catching"), ballTab:AddLeftGroupbox("Swatting");
      
    local catchToggle = catchBox:AddToggle("CatchEnabled", {
        Text = "Enabled",
        Default = constructor.Settings.BALL.CATCHING.ENABLED;
        Callback = function(value)
            constructor.Settings.BALL.CATCHING.ENABLED = value;
        end
    });
    
    catchToggle:AddKeyPicker("CatchKeybind", {
        Default = "Q",
        Mode = "Toggle",
        SyncToggleState = true
    })

    catchBox:AddSlider("CatchSlider", {
        Text = "Distance",
        Default = constructor.Settings.BALL.CATCHING.DISTANCE, -- use settings here
        Min = 1,
        Max = 15,
        Rounding = 0,
        Callback = function(value)
            constructor.Settings.BALL.CATCHING.DISTANCE = value;
        end 
    });

    local swatToggle = swatBox:AddToggle("SwatEnabled", {
        Text = "Enabled",
        Default = constructor.Settings.BALL.SWATTING.ENABLED;
        Callback = function(value)
            constructor.Settings.BALL.SWATTING.ENABLED = value;
        end
    });
    
    swatToggle:AddKeyPicker("SwatKeybind", {
        Default = "Q",
        Mode = "Toggle",
        SyncToggleState = true
    })

    swatBox:AddSlider("SwatSlider", {
        Text = "Distance",
        Default = constructor.Settings.BALL.SWATTING.DISTANCE, -- use settings here
        Min = 1,
        Max = 15,
        Rounding = 0,
        Callback = function(value)
            constructor.Settings.BALL.SWATTING.DISTANCE = value;
        end 
    });
end