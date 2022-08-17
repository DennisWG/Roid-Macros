--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local Roids = _G.Roids or {}

-- Returns information regarding the macro the button is holing. 
-- buttonId: The id of the button we're trying to get information from
-- returns: nil if the button doesn't hold a macro. Otherwhise the macro's name, texture path and a list of lines that form the macro's body
function Roids.GetMacroInfo(buttonId)
    local macroName = GetActionText(buttonId);
    
    if not macroName then
        return nil;
    end
    
    local name, texture, body = GetMacroInfo(GetMacroIndexByName(macroName));
    
    return name, texture, Roids.splitString(body, "\n");
end

-- Returns all spells the current player has learned
function Roids.GetLearnedSpells()
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
function Roids.SanitizeSpellName(name)
    return string.lower(string.gsub(name,"%s*",""));
end

-- Returns whether or not the given name is a spell
function Roids.IsSpell(name)
    local name = Roids.SanitizeSpellName(name);
    local spells = Roids.GetLearnedSpells();
    
    for k,v in pairs(spells) do
        local knownName = Roids.SanitizeSpellName(v.name.."("..v.rank..")");
        if knownName == name then
            return true;
        end
    end
    
    return false;
end

local Extension = Roids.RegisterExtension("Generic_show");
Extension.RegisterEvent("PLAYER_ENTERING_WORLD", "PLAYER_ENTERING_WORLD");
Extension.RegisterEvent("SPELLS_CHANGED", "SPELLS_CHANGED");

function Extension.OnLoad()
end

function Roids.ParseSpell(line)
    local rankStart, rankEnd = string.find(line, Roids.Localized.SpellRank);
    local spellName, spellRank;
    
    if rankStart then
        spellName = Roids.Trim(string.sub(line, 0, rankStart - 1));
        spellRank = Roids.Trim(string.sub(line, rankStart + 1, rankEnd - 1));
    else
        spellName = Roids.Trim(line);
    end
    
    local spell = Roids.knownSpells[spellName];
    if not spell then
        return false;
    end
    
    local spellSlot = spell[spellRank or "highest"];
    GameTooltip:SetSpell(spellSlot, "player");
    
    return true;
end

function Roids.ParseItem(line)
    local bag, slot = Roids.FindItem(Roids.Trim(line));
    
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
    Roids.knownSpells = Roids.GetLearnedSpells();
    
    if not Roids.Hooks.GameTooltip_SetAction then
        Roids.Hooks.GameTooltip_SetAction = GameTooltip.SetAction;
        
        GameTooltip.SetAction = function(this, buttonId)
            local name, texture, body = Roids.GetMacroInfo(buttonId);
        
            if not name then
                return Roids.Hooks.GameTooltip_SetAction(this, buttonId);
            end
            
            for _,line in pairs(body) do
                if string.find(line, "^#showtooltip ") then
                    local text = string.sub(line, 14);
                    if Roids.ParseSpell(text) then
                        return;
                    end
                    
                    if Roids.ParseItem(text) then
                        return;
                    end
                    
                    Roids.Print("Unknown Tooltip: '"..text.."'");
                end
            end
        end
    end
end

function Extension.SPELLS_CHANGED()
	Roids.knownSpells = Roids.GetLearnedSpells();
end
