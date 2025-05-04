local Constructor = {};
Constructor.__index = Constructor;

function Constructor.new()
    local self = setmetatable({}, Constructor); do
        self.Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/Library.lua"))();
        self.Settings = include("ui/settings");
    end

    self:_setup();

    return self;
end

function Constructor:_setup()
    local window = self.Library:CreateWindow({Title = "tobiware", 
        Footer = self.Settings.VERSION or "ERROR FETCHING VERSION";
        ToggleKeybind = self.Settings.UI_KEYBIND or Enum.KeyCode.RightControl;
        Center = true;
        AutoShow = self.Settings.UI_AUTOSHOW or true;
    })

    self._window = window;
    include("ui/tabs/ball")(self);
    include("ui/tabs/physics")(self);
end


return Constructor;