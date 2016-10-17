--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License

	Last Modified:
        10.16.2016 (DWG): Added MMC_splitString
]]

-- Splits the given string into a list of sub-strings
-- str: The string to split
-- seperatorPattern: The seperator between sub-string. May contain patterns
-- returns: A list of sub-strings
function MMC_splitString(str, seperatorPattern)
    local tbl = {};
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
