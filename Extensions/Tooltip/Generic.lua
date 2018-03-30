--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local MMC = _G.CastModifier or {}

-- Returns information regarding the macro the button is holing. 
-- buttonId: The id of the button we're trying to get information from
-- returns: nil if the button doesn't hold a macro. Otherwhise the macro's name, texture path and a list of lines that form the macro's body
function MMC.GetMacroInfo(buttonId)
    local macroName = GetActionText(buttonId);
    
    if not macroName then
        return nil;
    end
    
    local name, texture, body = GetMacroInfo(GetMacroIndexByName(macroName));
    
    return name, texture, MMC.splitString(body, "\n");
end

-- Returns all spells the current player has learned
function MMC.GetLearnedSpells()
    local i = 1
    local spells = {};
    while true do
        local spellName, spellRank = GetSpellName(i, BOOKTYPE_SPELL);
        if not spellName then
           break;
        end
       
        local list = spells[spellName] or {};
        if not list.spellRank then
            list[spellRank] = i;
            list.highest = i;
        end
        
        spells[spellName] = list;
        
        i = i + 1;
    end
    
    return spells;
end

-- Sanitizes the given name in a uniform way
-- returns: The name without white spaces and in lower case
function MMC.SanitizeSpellName(name)
    return string.lower(string.gsub(name,"%s*",""));
end

-- Returns whether or not the given name is a spell
function MMC.IsSpell(name)
    local name = MMC.SanitizeSpellName(name);
    local spells = MMC.GetLearnedSpells();
    
    for k,v in pairs(spells) do
        local knownName = MMC.SanitizeSpellName(v.name.."("..v.rank..")");
        if knownName == name then
            return true;
        end
    end
    
    return false;
end

local Extension = MMC.RegisterExtension("Generic_show");
Extension.RegisterEvent("PLAYER_ENTERING_WORLD", "PLAYER_ENTERING_WORLD");

function Extension.OnLoad()
end

function MMC.ParseSpell(line)
    local rankStart, rankEnd = string.find(line, MMC.Localized.SpellRank);
    local spellName, spellRank;
    
    if rankStart then
        spellName = MMC.Trim(string.sub(line, 0, rankStart - 1));
        spellRank = MMC.Trim(string.sub(line, rankStart + 1, rankEnd - 1));
    else
        spellName = MMC.Trim(line);
    end
    
    local spell = MMC.knownSpells[spellName];
    if not spell then
        return false;
    end
    
    local spellSlot = spell[spellRank or "highest"];
    GameTooltip:SetSpell(spellSlot, "player");
    
    return true;
end

function MMC.ParseItem(line)
    local bag, slot = MMC.FindItem(MMC.Trim(line));
    
    if not bag then
        return false;
    end
    
    if bag < 0 then
        GameTooltip:SetInventoryItem("player", -bag);
    end
    
    GameTooltip:SetBagItem(bag, slot);
    return true;
end

function Extension.PLAYER_ENTERING_WORLD()
    MMC.knownSpells = MMC.GetLearnedSpells();
    MMC.Hooks.GameTooltip_SetAction = GameTooltip.SetAction;
    
    GameTooltip.SetAction = function(this, buttonId)
        local name, texture, body = MMC.GetMacroInfo(buttonId);
    
        if not name then
            return MMC.Hooks.GameTooltip_SetAction(this, buttonId);
        end
        
        for _,line in pairs(body) do
            if string.find(line, "^#showtooltip ") then
                local text = string.sub(line, 14);
                if MMC.ParseSpell(text) then
                    return;
                end
                
                if MMC.ParseItem(text) then
                    return;
                end
                
                MMC.Print("Unknown Tooltip: '"..text.."'");
            end
        end
    end
end