local repo = "https://raw.githubusercontent.com/lzz2a/on-go/refs/heads/main/tobiware.lua";
local ui = repo .. "/ui";
local clases = repo .. "/classes";
local features = repo .. "/features";

local function check(path)
    if not isfolder(path) then
        makefolder(path);
    end
end

check("tobiware")
check("tobiware/ui");
check("tobiware/classes");
check("tobiware/features");

local classes_files = {"collisiongroup.lua"}
local ui_files = {"constructor.lua", "settings.lua"}
local features_files = {"mags.lua", "ladder_boost.lua"};

if not getgenv().debugMode then
    for i,v in pairs(classes_files) do
        local path = `tobiware/classes/{v}`
        writefile(path, game:HttpGet(`{classes}/{v}`))
    end

    for i,v in pairs(ui_files) do
        local path = `tobiware/ui/{v}`
        writefile(path, game:HttpGet(`{ui}/{v}`))
    end 

    for i,v in pairs(features_files) do
        local path = `tobiware/features/{v}`
        writefile(path, game:HttpGet(`{features}/{v}`))
    end 
end

getgenv().include = function(path)
	local fullPath = `tobiware/{path}.lua`;

	if not isfile(fullPath) then
		warn("[include] File not found:", fullPath);
		return;
	end

	local source = readfile(fullPath);
	local chunk, loadErr = loadstring(source, "@" .. fullPath);

	if not chunk then
		warn("[include] Load error in", path, ":", loadErr);
		return;
	end

	local success, result = pcall(chunk)

	if not success then
		warn("[include] Runtime error in", path, ":", result);
		return;
	end

	return result;
end


local ui = include("ui/constructor").new();
local mags = include("features/mags")(ui.Settings);
local ladder_boost = include("features/ladder_boost")(ui.Settings);

