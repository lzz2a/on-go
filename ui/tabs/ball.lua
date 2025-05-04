return function(constructor)
    local ballTab = constructor._window:AddTab("Ball");
    local catchBox, swatBox = ballTab:AddLeftGroupbox("Catching"), ballTab:AddLeftGroupbox("Swatting");
      
    catchBox:AddToggle("CatchEnabled", {
        Text = "Enabled",
        Default = constructor.Settings.BALL.CATCHING.ENABLED;
        Callback = function(value)
            constructor.Settings.BALL.CATCHING.ENABLED = value;
        end
    })
end