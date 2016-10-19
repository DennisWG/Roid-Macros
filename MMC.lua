--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License

	Last Modified:
        10.18.2016 (DWG): Restructured code and added Conditionals for [no]combat and [no]stealth
        10.17.2016 (DWG): Added Shapeshift Conditionals
        10.16.2016 (DWG): Implemented conditional casts
        10.16.2016 (DWG): Added comments
        10.16.2016 (DWG): Added license information
        2015 (DWG): Initial release
]]

-- Setup to wrap our stuff in a table so we don't pollute the global environment
local _G = _G or getfenv(0)
local MMC = _G.CastModifier or {}
_G.CastModifier = MMC
MMC.Hooks = MMC.Hooks or {}
-- Use MMC.Print(anything) for debug output


-- Validates that the given target is either friend (if [help]) or foe (if [harm])
-- target: The unit id to check
-- help: Optional. If set to 1 then the target must be friendly. If set to 0 it must be an enemy.
-- remarks: Will always return true if help is not given
-- returns: Whether or not the given target can either be attacked or supported, depending on help
function MMC.CheckHelp(target, help)
	if help then
		if help == 1 then
			if not UnitIsFriend(target, "player") then
				return false;
			end								
		else
			if UnitIsFriend(target, "player") then
				return false;
			end		
		end
	end
	return true;
end

-- Ensures the validity of the given target
-- target: The unit id to check
-- help: Optional. If set to 1 then the target must be friendly. If set to 0 it must be an enemy
-- returns: Whether or not the target is a viable target
function MMC.IsValidTarget(target, help)
	if target ~= "mouseover" then
		if not MMC.CheckHelp(target, help) or not UnitExists(target) then
			return false;
		end
		return true;
	end
	
	if (not CM or not CM.currentUnit) and not UnitName("mouseover") then
		return false;
	end
	
	return MMC.CheckHelp(target, help);
end

-- Returns the current shapeshift / stance index
-- returns: The index of the current shapeshift form / stance. 0 if in no shapeshift form / stance
function MMC.GetCurrentShapeshiftIndex()
    for i=1, GetNumShapeshiftForms() do
        _, _, active = GetShapeshiftFormInfo(i);
        if active then
            return i; 
        end
    end
    
    return 0;
end

-- Checks whether or not the given textureName is present in the current player's buff bar
-- textureName: The full name (including path) of the texture
-- returns: True if the texture can be found, false otherwhise
function MMC.HasBuff(textureName)
    for i = 1, 16 do
        if UnitBuff("player", i) == textureName then
            return true;
        end
    end
    
    return false;
end

-- A list of Conditionals and their functions to validate them
MMC.Keywords = {
    stance = function(conditionals)
        local inStance = false;
        for k,v in pairs(MMC.splitString(conditionals.stance, "/")) do
            if MMC.GetCurrentShapeshiftIndex() == tonumber(v) then
                inStance = true;
                break;
            end
        end
        
        if not inStance then
            return false;
        end
        return true;
    end,
    
    mod = function(conditionals)    
        if conditionals.mod == "alt" and IsAltKeyDown() then
            return true;
        elseif conditionals.mod == "ctrl" and IsControlKeyDown() then
            return true;
        elseif conditionals.mod == "shift" and IsShiftKeyDown() then
            return true;
        end
        
        return false;
    end,
    
    target = function(conditionals)
        return MMC.IsValidTarget(conditionals.target, conditionals.help);
    end,
    
    combat = function(conditionals)
        return UnitAffectingCombat("player");
    end,
    
    nocombat = function(conditionals)
        return not UnitAffectingCombat("player");
    end,
    
    stealth = function(conditionals)
        return MMC.HasBuff("Interface\\Icons\\Ability_Ambush");
    end,
    
    nostealth = function(conditionals)
        return not MMC.HasBuff("Interface\\Icons\\Ability_Ambush");
    end,
};

-- Parses the given message and looks for any conditionals
-- msg: The message to parse
-- returns: A set of conditionals found inside the given string
function MMC.parseMsg(msg)
	local modifier;
	local modifierEnd = string.find(msg, "]");
	local help = nil;
	
    -- If we find conditionals trim down the message to everything except the conditionals
	if string.sub(msg, 1, 1) == "[" and modifierEnd then
		modifier = string.sub(msg, 2, modifierEnd - 1);
		msg = string.sub(msg, modifierEnd + 2);
    -- No conditionals found. Just return the message as is
	else
		return msg;
	end
	
    local target;
    local conditionals = {};
    
    local pattern = "(@*%w+:*%w*/*%w*)";
    for w in string.gfind(modifier, pattern) do
        local delimeter = string.find(w, ":");
        -- x:y
        if delimeter then
            local conditional = string.sub(w, 1, delimeter - 1);
            conditionals[conditional] = string.sub(w, delimeter + 1);
        -- @target
        elseif string.sub(w, 1, 1) == "@" then
            conditionals["target"] = string.sub(w,  2);
        -- Any other keyword like harm or help
        elseif MMC.Keywords[w] ~= nil then
            conditionals[w] = 1;
        end
    end
    
	return msg, conditionals;
end

-- A very primitive way of trying to verify that the given target is the same as the player's current target
-- target: The target to check
-- returns: True if the target and the player's target share some values
function MMC.VerifyIdentity(target)
    local plvl = UnitLevel("playertarget");
    local tlvl = UnitLevel(target);
    local pmana = UnitMana("playertarget");
    local tmana = UnitMana(target);
    local pmaxmana = UnitManaMax("playertarget");
    local tmaxmana = UnitManaMax(target);
    
    return plvl == tlvl and pmana == tmana and pmaxmana == tmaxmana;
end

-- Attempts to cast a single spell
-- msg: The conditions followed by the spell name
-- returns: True if the spell has been casted. False if it has not.
function MMC.DoCastOne(msg)
    local msg, conditionals = MMC.parseMsg(msg);
    
    -- No conditionals. Just exit.
    if not conditionals then
        if not msg then
            return false;
        else
            MMC.Hooks.CAST_SlashCmd(msg);
            return true;
        end
    end
    
    if not conditionals.target then
        if UnitExists("target") then
            conditionals.target = "target";
        else
            conditionals.target = "player";
        end
    end
    
    local help = nil;
    if conditionals.help then
        help = 1;
    elseif conditionals.harm then
        help = 0;
    end
    
    for k, v in pairs(conditionals) do
        if not MMC.Keywords[k] or not MMC.Keywords[k](conditionals) then
            return false;
        end
    end
        
    if target == "mouseover" then
        if help == 0 then
            TargetUnit(target);
            CastSpellByName(msg);
            return true;
        end
        CM:Cast(msg);
        return true;
    end
    
    local needRetarget = false;
    -- if our current target is not equal to the specified target...
    if not MMC.VerifyIdentity(conditionals.target) then
        needRetarget = true;
    end
    
    TargetUnit(conditionals.target);
    CastSpellByName(msg);
    
    -- ... then we have to re-target it after casting the spell!
    if needRetarget then
        TargetLastTarget();
    end
    
    return true;
end

-- Attempts to cast a single spell from the given set of conditional spells
-- msg: The player's macro text
function MMC.DoCast(msg)
    local handled = false;
    for k, v in pairs(MMC.splitString(msg, ";%s*")) do
        if MMC.DoCastOne(v) then
            handled = true; -- we parsed at least one command
            break;
        end
    end
    return handled;
end

-- Dummy Frame to hook ADDON_LOADED event in order to preserve compatiblity with other AddOns like SuperMacro
MMC.Frame = CreateFrame("FRAME");
MMC.Frame:SetScript("OnEvent", function()
    if event ~= "ADDON_LOADED" or arg1 ~= "SuperMacro" then
        return;
    end
    
    -- Hook SuperMacro's RunLine to stay compatible
    MMC.Hooks.RunLine = RunLine
    MMC.RunLine = function(...)
        for k = 1, arg.n do
            local text = arg[k];
            -- if we find '/cast [' take over execution
            local begin, _end = string.find(text, "^/cast%s*%[");
            if begin then
                local msg = string.sub(text, _end);
                MMC.DoCast(msg);
            -- if not pass it along to SuperMacro
            else
                MMC.Hooks.RunLine(text);
            end
        end
    end
    RunLine = MMC.RunLine
end);
MMC.Frame:RegisterEvent("ADDON_LOADED");

MMC.Hooks.CAST_SlashCmd = SlashCmdList["CAST"]
MMC.CAST_SlashCmd = function(msg)
    -- get in there first, i.e do a PreHook
    if MMC.DoCast(msg) then
        return
    end
    -- if there was nothing for us to handle pass it to the original
    MMC.Hooks.CAST_SlashCmd(msg)
end
SlashCmdList["CAST"] = MMC.CAST_SlashCmd
