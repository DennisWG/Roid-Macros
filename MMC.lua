--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]

-- Setup to wrap our stuff in a table so we don't pollute the global environment
local _G = _G or getfenv(0);
local MMC = _G.CastModifier or {};
_G.CastModifier = MMC;
MMC.Hooks = MMC.Hooks or {};
MMC.mouseoverUnit = MMC.mouseoverUnit or nil;

MMC.Extensions = MMC.Extensions or {};

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
    local retarget = false;
    
    if target == "focus" then
        if not ClassicFocus_CurrentFocus then
            return false;
        end
        SlashCmdList["TARGET"](ClassicFocus_CurrentFocus);
        target = "target";
        retarget = true;
    end
    
	if target ~= "mouseover" then
		if not MMC.CheckHelp(target, help) or not UnitExists(target) then
            if retarget then
                TargetLastTarget();
            end
			return false;
		end
		return true;
	end
	
	if (not MMC.mouseoverUnit) and not UnitName("mouseover") then
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

-- Maps easy to use weapon type names (e.g. Axes, Shields) to their inventory slot name and their localized tooltip name
MMC.WeaponTypeNames = {
    Daggers = { slot = "MainHandSlot", name = MMC.Localized.Dagger },
    Fists =  { slot = "MainHandSlot", name = MMC.Localized.FistWeapon },
    Axes =  { slot = "MainHandSlot", name = MMC.Localized.Axe },
    Swords =  { slot = "MainHandSlot", name = MMC.Localized.Sword },
    Staffs =  { slot = "MainHandSlot", name = MMC.Localized.Staff },
    Maces =  { slot = "MainHandSlot", name = MMC.Localized.Mace },
    Polearms =  { slot = "MainHandSlot", name = MMC.Localized.Polearm },
    Shields = { slot = "SecondaryHandSlot", name = MMC.Localized.Shield },
    Guns = { slot = "RangedSlot", name = MMC.Localized.Gun },
    Crossbows = { slot = "RangedSlot", name = MMC.Localized.Crossbow },
    Bows = { slot = "RangedSlot", name = MMC.Localized.Bow },
    Thrown = { slot = "RangedSlot", name = MMC.Localized.Thrown },
    Wands = { slot = "RangedSlot", name = MMC.Localized.Wand },
};

-- Checks whether or not the given weaponType is currently equipped
-- weaponType: The name of the weapon's type (e.g. Axe, Shield, etc.)
-- returns: True when equipped, otherwhise false
function MMC.HasWeaponEquipped(weaponType)
    if not MMC.WeaponTypeNames[weaponType] then
        return false;
    end
    
	MMCTooltip:SetOwner(UIParent, "ANCHOR_NONE");
    
    local slotName = MMC.WeaponTypeNames[weaponType].slot;
    local localizedName = MMC.WeaponTypeNames[weaponType].name;

    local slotId = GetInventorySlotInfo(slotName);
    hasItem = MMCTooltip:SetInventoryItem("player", slotId);
    if not hasItem then
        return false;
    end
    
	local lines = MMCTooltip:NumLines();
	for i = 1, lines do
		local label = getglobal("MMCTooltipTextLeft"..i);
		if label:GetText() then
			if label:GetText() == localizedName then
                return true;
            end
		end
        
		label = getglobal("MMCTooltipTextRight"..i);
		if label:GetText() then
			if label:GetText() == localizedName then
                return true;
            end
		end
    end
    
    return false;
end

-- Checks whether or not the given UnitId is in your party or your raid
-- target: The UnitId of the target to check
-- groupType: The name of the group type your target has to be in ("party" or "raid")
-- returns: True when the given target is in the given groupType, otherwhise false
function MMC.IsTargetInGroupType(target, groupType)
    local upperBound = 5;
    if groupType == "raid" then
        upperBound = 40;
    end
    
    for i = 1, upperBound do
        if UnitName(groupType..i) == UnitName(target) then
            return true;
        end
    end
    
    return false;
end

-- Checks whether or not we're currently casting a channeled spell
function MMC.CheckChanneled(conditionals)
    --MMC.CurrentSpell
    if MMC.CurrentSpell.type == "channeled" and MMC.CurrentSpell.spellName == conditionals.channeled then
        return false;
    end
    
    if conditionals.channeled == MMC.Localized.Attack then
        return not MMC.CurrentSpell.autoAttack;
    end
    
    MMC.CurrentSpell.spellName = conditionals.channeled;
    return true;
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
    
    equipped = function(conditionals)
        return MMC.HasWeaponEquipped(conditionals.equipped);
    end,
    
    dead = function(conditionals)
        return UnitIsDeadOrGhost(conditionals.target);
    end,
    
    nodead = function(conditionals)
        return not UnitIsDeadOrGhost(conditionals.target);
    end,
    
    party = function(conditionals)
        return MMC.IsTargetInGroupType(conditionals.target, "party");
    end,
    
    raid = function(conditionals)
        return MMC.IsTargetInGroupType(conditionals.target, "raid");
    end,
    
    group = function(conditionals)
        if conditionals.group == "party" then
            return GetNumPartyMembers() > 0;
        elseif conditionals.group == "raid" then
            return GetNumRaidMembers() > 0;
        end
        return false;
    end,
    
    channeled = function(conditionals)
        return MMC.CheckChanneled(conditionals);
    end,
};

-- Parses the given message and looks for any conditionals
-- msg: The message to parse
-- returns: A set of conditionals found inside the given string
function MMC.parseMsg(msg)
	local modifier = "";
	local modifierEnd = string.find(msg, "]");
	local help = nil;
	
    -- If we find conditionals trim down the message to everything except the conditionals
	if string.sub(msg, 1, 1) == "[" and modifierEnd then
		modifier = string.sub(msg, 2, modifierEnd - 1);
		msg = string.sub(msg, modifierEnd + 2);
    -- No conditionals found. Just return the message as is
	elseif string.sub(msg, 1, 1) ~= "!" then
		return msg;
	end
	
    local target;
    local conditionals = {};
    
    
    if string.sub(msg, 1, 1) == "!" then
        msg = string.sub(msg, 2);
        conditionals.channeled = msg;
    end
    
    local pattern = "(@?%w+:*%w*/*%w*)";
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
    
    if conditionals.target == "mouseover" then
        if not UnitExists("mouseover") then
            conditionals.target = MMC.mouseoverUnit;
        end
        if not conditionals.target or not UnitExists(conditionals.target) then
            return false;
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
    
    if conditionals.target == "focus" and ClassicFocus_CurrentFocus then
        SlashCmdList["TARGET"](ClassicFocus_CurrentFocus);
        conditionals.target = "target";
        needRetarget = true;
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

-- Holds information about the currently cast spell
MMC.CurrentSpell = {
    -- "channeled" or "cast"
    type = "",
    -- the name of the spell
    spellName = "",
    -- is the Attack ability enabled
    autoAttack = false,
};

-- Dummy Frame to hook ADDON_LOADED event in order to preserve compatiblity with other AddOns like SuperMacro
MMC.Frame = CreateFrame("FRAME");
MMC.Frame:RegisterEvent("ADDON_LOADED");
MMC.Frame:RegisterEvent("SPELLCAST_CHANNEL_START");
MMC.Frame:RegisterEvent("SPELLCAST_CHANNEL_STOP");
MMC.Frame:RegisterEvent("SPELLCAST_INTERRUPTED");
MMC.Frame:RegisterEvent("SPELLCAST_FAILED");
MMC.Frame:RegisterEvent("PLAYER_ENTER_COMBAT");
MMC.Frame:RegisterEvent("PLAYER_LEAVE_COMBAT");

MMC.Frame:SetScript("OnEvent", function()
    MMC.Frame[event]();
end);

function MMC.Frame.ADDON_LOADED()
    if event ~= "ADDON_LOADED" then
        return;
    end
    
    if arg1 == "CastModifier" then
        MMC.InitializeExtensions();
        return;
    end
    
    if arg1 ~= "SuperMacro" then
        return;
    end
    
    -- Hook SuperMacro's RunLine to stay compatible
    MMC.Hooks.RunLine = RunLine;
    MMC.RunLine = function(...)
        for k = 1, arg.n do
            local text = arg[k];
            -- if we find '/cast [' take over execution
            local begin, _end = string.find(text, "^/cast%s+!?%[?");
            if begin then
                local msg = string.sub(text, _end);
                MMC.DoCast(msg);
            -- if not pass it along to SuperMacro
            else
                MMC.Hooks.RunLine(text);
            end
        end
    end
    RunLine = MMC.RunLine;
end

function MMC.Frame.SPELLCAST_CHANNEL_START()
    MMC.CurrentSpell.type = "channeled";
end

function MMC.Frame.SPELLCAST_CHANNEL_STOP()
    MMC.CurrentSpell.type = "";
    MMC.CurrentSpell.spellName = "";
end

MMC.Frame.SPELLCAST_INTERRUPTED = MMC.Frame.SPELLCAST_CHANNEL_STOP;
MMC.Frame.SPELLCAST_FAILED = MMC.Frame.SPELLCAST_CHANNEL_STOP;

function MMC.Frame.PLAYER_ENTER_COMBAT()
    MMC.CurrentSpell.autoAttack = true;
end

function MMC.Frame.PLAYER_LEAVE_COMBAT()
    MMC.CurrentSpell.autoAttack = false;
end

MMC.Hooks.CAST_SlashCmd = SlashCmdList["CAST"];
MMC.CAST_SlashCmd = function(msg)
    -- get in there first, i.e do a PreHook
    if MMC.DoCast(msg) then
        return;
    end
    -- if there was nothing for us to handle pass it to the original
    MMC.Hooks.CAST_SlashCmd(msg);
end

SlashCmdList["CAST"] = MMC.CAST_SlashCmd;

SLASH_MMC1 = "/rl"
SlashCmdList["MMC"] = function() ReloadUI(); end
