--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local Roids = _G.Roids or {} -- redundant since we're loading first but peace of mind if another file is added top of chain

-- Splits the given string into a list of sub-strings
-- str: The string to split
-- seperatorPattern: The seperator between sub-string. May contain patterns
-- returns: A list of sub-strings
function Roids.splitString(str, seperatorPattern)
    local tbl = {};
    if not str then
        return tbl;
    end
    local pattern = "(.-)" .. seperatorPattern;
    local lastEnd = 1;
    local s, e, cap = string.find(str, pattern, 1);
   
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(tbl,cap);
        end
        lastEnd = e + 1;
        s, e, cap = string.find(str, pattern, lastEnd);
    end
    
    if lastEnd <= string.len(str) then
        cap = string.sub(str, lastEnd);
        table.insert(tbl, cap);
    end
    
    return tbl
end

-- Prints all the given arguments into WoW's default chat frame
function Roids.Print(...)
    if not DEFAULT_CHAT_FRAME:IsVisible() then
        FCF_SelectDockFrame(DEFAULT_CHAT_FRAME)
    end
    local out = "|cffc8c864Roids:|r";
    
    for i=1, arg.n, 1 do
        out = out..tostring(arg[i]).."  ";
    end
    
    DEFAULT_CHAT_FRAME:AddMessage(out)
end

-- Trims any leading or trailing white space characters from the given string
-- str: The string to trim
-- returns: The trimmed string
function Roids.Trim(str)
    if not str then
        return nil;
    end
    return string.gsub(str,"^%s*(.-)%s*$", "%1");
end

_G["Roids"] = Roids
