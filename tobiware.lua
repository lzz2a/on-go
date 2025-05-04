local repo = "https://raw.githubusercontent.com/lzz2a/on-go/refs/heads/main/tobiware.lua";

local function check(path)
    if not isfolder(path) then
        makefolder(path);
    end
end

check("tobiware")
check("tobiware/features");

