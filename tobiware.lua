local repo = "https://raw.githubusercontent.com/lzz2a/on-go/refs/heads/main/tobiware.lua";
local ui = repo .. "/ui";
local features = repo .. "/features";

local function check(path)
    if not isfolder(path) then
        makefolder(path);
    end
end

check("tobiware")
check("tobiware/ui");
check("tobiware/features");

local ui_files = {"constructor.lua","handler.lua"}
local features_files = {"mags.lua", "dynamic_jump.lua"};

for i,v in pairs(ui_files) do
    local path = `tobiware/ui/{v}`
    writefile(path, game:HttpGet(`{ui}/{v}`))
end 

for i,v in pairs(features_files) do
    local path = `tobiware/features/{v}`
    writefile(path, game:HttpGet(`{features}/{v}`))
end 

getgenv().include = function(path)
    return loadfile(`{path}.lua`);
end

local ui = include("ui/constructor");

