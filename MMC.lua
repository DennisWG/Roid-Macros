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
            return UnitCanAssist("player", target);
		else
			return UnitCanAttack("player", target);
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

-- Checks whether or not the given buffName is present on the given unit's buff bar
-- buffName: The name of the buff
-- unit: The UnitID of the unit to check
-- returns: True if the buffName can be found, false otherwhise
function MMC.HasBuffName(buffName, unit)
    if not buffName or not unit then
        return false;
    end
    
    local text = getglobal(MMCTooltip:GetName().."TextLeft1");
	for i=1, 16 do
		MMCTooltip:SetOwner(UIParent, "ANCHOR_NONE");
		MMCTooltip:SetUnitBuff(unit, i);
		name = text:GetText();
		MMCTooltip:Hide();
        buffName = string.gsub(buffName, "_", " ");
		if ( name and string.find(name, buffName) ) then
			return true;
		end
    end
    
    return false;
end

-- Checks whether or not the given buffName is present on the given unit's debuff bar
-- buffName: The name of the debuff
-- unit: The UnitID of the unit to check
-- returns: True if the buffName can be found, false otherwhise
function MMC.HasDeBuffName(buffName, unit)
    if not buffName or not unit then
        return false;
    end
    
    local text = getglobal(MMCTooltip:GetName().."TextLeft1");
	for i=1, 16 do
		MMCTooltip:SetOwner(UIParent, "ANCHOR_NONE");
		MMCTooltip:SetUnitDebuff(unit, i);
		name = text:GetText();
		MMCTooltip:Hide();
        buffName = string.gsub(buffName, "_", " ");
		if ( name and string.find(name, buffName) ) then
			return true;
		end
    end
    
    return false;
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
    -- Remove the "(Rank X)" part from the spells name in order to allow downranking
    local spellName = string.gsub(MMC.CurrentSpell.spellName, "%(.-%)%s*", "");
    local channeled = string.gsub(conditionals.checkchanneled, "%(.-%)%s*", "");
    
    if MMC.CurrentSpell.type == "channeled" and spellName == channeled then
        return false;
    end
    
    if channeled == MMC.Localized.Attack then
        return not MMC.CurrentSpell.autoAttack;
    end
    
    if channeled == MMC.Localized.AutoShot then
        return not MMC.CurrentSpell.autoShot;
    end
    
    MMC.CurrentSpell.spellName = channeled;
    return true;
end

-- Checks whether or not the given unit has more or less power in percent than the given amount
-- unit: The unit we're checking
-- bigger: 1 if the percentage needs to be bigger, 0 if it needs to be lower
-- amount: The required amount
-- returns: True or false
function MMC.ValidatePower(unit, bigger, amount)
    local powerPercent = 100 / UnitManaMax(unit) * UnitMana(unit);
    if bigger == 0 then
        return powerPercent < tonumber(amount);
    end
    
    return powerPercent > tonumber(amount);
end

-- Checks whether or not the given unit has more or less total power than the given amount
-- unit: The unit we're checking
-- bigger: 1 if the raw power needs to be bigger, 0 if it needs to be less
-- amount: The required amount
-- returns: True or false
function MMC.ValidateRawPower(unit, bigger, amount)
    local power = UnitMana(unit);
    if bigger == 0 then
        return power < tonumber(amount);
    end
    
    return power > tonumber(amount);
end

-- Checks whether or not the given unit has more or less hp in percent than the given amount
-- unit: The unit we're checking
-- bigger: 1 if the percentage needs to be bigger, 0 if it needs to be lower
-- amount: The required amount
-- returns: True or false
function MMC.ValidateHp(unit, bigger, amount)
    local powerPercent = 100 / UnitHealthMax(unit) * UnitHealth(unit);
    if bigger == 0 then
        return powerPercent < tonumber(amount);
    end
    
    return powerPercent > tonumber(amount);
end

-- Checks whether the given creatureType is the same as the target's creature type
-- creatureType: The type to check
-- target: The target's unitID
-- returns: True or false
-- remarks: Allows for both localized and unlocalized type names
function MMC.ValidateCreatureType(creatureType, target)
    local targetType = UnitCreatureType(target);
    local englishType = MMC.Localized.CreatureTypes[targetType];
    return creatureType == targetType or creatureType == englishType;
end

-- Returns the cooldown of the given spellName or nil if no such spell was found
function MMC.GetSpellCooldownByName(spellName)
    local checkFor = function(bookType)
        local i = 1
        while true do
            local name, spellRank = GetSpellName(i, bookType);
            
            if not name then
                break;
            end
            
            if name == spellName then
                local _, duration = GetSpellCooldown(i, bookType);
                return duration;
            end
            
            i = i + 1
        end
        return nil;
    end
    
    
    local cd = checkFor(BOOKTYPE_PET);
    if not cd then cd = checkFor(BOOKTYPE_SPELL); end
    
    return cd;
end

-- Returns the cooldown of the given equipped itemName or nil if no such item was found
function MMC.GetInventoryCooldownByName(itemName)
    MMCTooltip:SetOwner(UIParent, "ANCHOR_NONE");
    for i=0, 19 do
        MMCTooltip:ClearLines();
        hasItem = MMCTooltip:SetInventoryItem("player", i);
        
        if hasItem then
            local lines = MMCTooltip:NumLines();
            
            local label = getglobal("MMCTooltipTextLeft1");
            
            if label:GetText() == itemName then
                local _, duration, _ = GetInventoryItemCooldown("player", i);
                return duration;
            end
        end
    end
    
    return nil;
end

-- Returns the cooldown of the given itemName in the player's bags or nil if no such item was found
function MMC.GetContainerItemCooldownByName(itemName)
    MMCTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
    
    for i = 0, 4 do
        for j = 1, GetContainerNumSlots(i) do
            MMCTooltip:ClearLines();
            MMCTooltip:SetBagItem(i, j);
            if MMCTooltipTextLeft1:GetText() == itemName then
                local _, duration, _ = GetContainerItemCooldown(i, j);
                return duration;
            end
        end
    end
    
    return nil;
end

-- A list of Conditionals and their functions to validate them
MMC.Keywords = {
    help = function(conditionals)
        return true;
    end,
    
    harm = function(conditionals)
        return true;
    end,
    
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
        local modifiersPressed = true;
        
        for k,v in pairs(MMC.splitString(conditionals.mod, "/")) do
            if v == "alt" and not IsAltKeyDown() then
                modifiersPressed = false;
                break;
            elseif v == "ctrl" and not IsControlKeyDown() then
                modifiersPressed = false;
                break;
            elseif v == "shift" and not IsShiftKeyDown() then
                modifiersPressed = false;
                break;
            end
        end
        
        return modifiersPressed;
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
    
    checkchanneled = function(conditionals)
        return MMC.CheckChanneled(conditionals);
    end,
    
    buff = function(conditionals)
        return MMC.HasBuffName(conditionals.buff, conditionals.target);
    end,
    
    nobuff = function(conditionals)
        return not MMC.HasBuffName(conditionals.nobuff, conditionals.target);
    end,
    
    debuff = function(conditionals)
        return MMC.HasDeBuffName(conditionals.debuff, conditionals.target);
    end,
    
    nodebuff = function(conditionals)
        return not MMC.HasDeBuffName(conditionals.nodebuff, conditionals.target);
    end,
    
    mybuff = function(conditionals)
        return MMC.HasBuffName(conditionals.mybuff, "player");
    end,
    
    nomybuff = function(conditionals)
        return not MMC.HasBuffName(conditionals.nomybuff, "player");
    end,
    
    mydebuff = function(conditionals)
        return MMC.HasDeBuffName(conditionals.mydebuff, "player");
    end,
    
    nomydebuff = function(conditionals)
        return not MMC.HasDeBuffName(conditionals.nomydebuff, "player");
    end,
    
    power = function(conditionals)
        return MMC.ValidatePower(conditionals.target, conditionals.power.bigger, conditionals.power.amount);
    end,
    
    mypower = function(conditionals)
        return MMC.ValidatePower("player", conditionals.mypower.bigger, conditionals.mypower.amount);
    end,
    
    rawpower = function(conditionals)
        return MMC.ValidateRawPower(conditionals.target, conditionals.rawpower.bigger, conditionals.rawpower.amount);
    end,
    
    myrawpower = function(conditionals)
        return MMC.ValidateRawPower("player", conditionals.myrawpower.bigger, conditionals.myrawpower.amount);
    end,
    
    hp = function(conditionals)
        return MMC.ValidateHp(conditionals.target, conditionals.hp.bigger, conditionals.hp.amount);
    end,
    
    myhp = function(conditionals)
        return MMC.ValidateHp("player", conditionals.myhp.bigger, conditionals.myhp.amount);
    end,
    
    type = function(conditionals)
        return MMC.ValidateCreatureType(conditionals.type, conditionals.target);
    end,
    
    cooldown = function(conditionals)
        local name = string.gsub(conditionals.cooldown, "_", " ");
        local cd = MMC.GetSpellCooldownByName(name);
        if not cd then cd = MMC.GetInventoryCooldownByName(name); end
        if not cd then cd = MMC.GetContainerItemCooldownByName(name) end
        return cd > 0;
    end,
    
    nocooldown = function(conditionals)
        local name = string.gsub(conditionals.nocooldown, "_", " ");
        local cd = MMC.GetSpellCooldownByName(name);
        if not cd then cd = MMC.GetInventoryCooldownByName(name); end
        if not cd then cd = MMC.GetContainerItemCooldownByName(name) end
        return cd == 0;
    end,
    
    channeled = function(conditionals)
        return MMC.CurrentSpell.spellName ~= "";
    end,
    
    nochanneled = function(conditionals)
        return MMC.CurrentSpell.spellName == "";
    end,
};

-- Attempts to execute a macro by the given name
-- name: The name of the macro
-- returns: Whether the macro was executed or not
function MMC.ExecuteMacroByName(name)
    local macroId = GetMacroIndexByName(name);
    if not macroId then
        return false;
    end
    
    local _,_, body = GetMacroInfo(macroId);
    if not body then
        return false;
    end
    
    local lines = MMC.splitString(body, "\n");
    for k,v in pairs(lines) do
        ChatFrameEditBox:SetText(v);
        ChatEdit_SendText(ChatFrameEditBox);
    end
end

-- Searches for a ':', '>' or '<' in the given word and returns its position
-- word: The word to search in
-- returns: The position of the delimeter or nil and 1 for '>' or 2 for '<'
function MMC.FindDelimeter(word)
    local delimeter = string.find(word, ":");
    local which = nil;
    
    if not delimeter then
        delimeter = string.find(word, ">");
        which = 1;
        if not delimeter then
            delimeter = string.find(word, "<");
            which = 0;
        end
    end
    
    if not delimeter then
        which = nil;
    end
    
    return delimeter, which;
end

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
		msg = string.sub(msg, modifierEnd + 1);
    -- No conditionals found. Just return the message as is
	elseif string.sub(msg, 1, 1) ~= "!" then
		return msg;
	end
	
    local target;
    local conditionals = {};
    
    
    if string.sub(msg, 1, 1) == "!" then
        msg = string.sub(msg, 2);
        conditionals.checkchanneled = msg;
    end
        
    local pattern = "(@?%w+:?>?<?%w*[_?%w*]*[/?%w*]*)";
    for w in string.gfind(modifier, pattern) do
        local delimeter, which = MMC.FindDelimeter(w);
        -- x:y
        if delimeter then
            local conditional = string.sub(w, 1, delimeter - 1);
            if which then
                conditionals[conditional] = { bigger = which, amount = string.sub(w, delimeter + 1) };
            else
                conditionals[conditional] = string.sub(w, delimeter + 1);
            end
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

function MMC.SetHelp(conditionals)
    if conditionals.help then
        conditionals.help = 1;
    elseif conditionals.harm then
        conditionals.help = 0;
    end
end

-- Fixes the conditionals' target by using the player's current target if it exists or falling back to the player itself if it doesn'target
-- conditionals: The conditionals containing the current target
-- returns: Whether or not we've changed the player's current target
function MMC.FixEmptyTarget(conditionals)
    if not conditionals.target then
        if UnitExists("target") then
            conditionals.target = "target";
        else
            conditionals.target = "player";
        end
    end
    
    return false;
end

-- Fixes the conditionals' target by targeting the target with the given name
-- conditionals: The conditionals containing the current target
-- name: The name of the player to target
-- hook: The target hook
-- returns: Whether or not we've changed the player's current target
function MMC.FixEmptyTargetSetTarget(conditionals, name, hook)
    if not conditionals.target then
        hook(name);
        conditionals.target = "target";
        return true;
    end
    return false;
end

-- Returns the name of the focus target or nil
function MMC.GetFocusName()
    if ClassicFocus_CurrentFocus then
        return ClassicFocus_CurrentFocus;
    elseif CURR_FOCUS_TARGET then
        return CURR_FOCUS_TARGET;
    end
    
    return nil;
end

-- Attempts to target the focus target.
-- returns: Whether or not it succeeded
function MMC.TryTargetFocus()
    local name = MMC.GetFocusName();
    if not name then
        return false;
    end
    
    MMC.Hooks.TARGET_SlashCmd(name);
    return true;
end

-- Does the given action with a set of conditionals provided by the given msg
-- msg: The conditions followed by the action's parameters
-- hook: The hook of the function we've intercepted
-- fixEmptyTargetFunc: A function setting the player's target if the player has none. Required to return true if we need to re-target later or false if not
-- targetBeforeAction: A boolean value that determines whether or not we need to target the target given in the conditionals before performing the given action
-- action: A function that is being called when everything checks out
function MMC.DoWithConditionals(msg, hook, fixEmptyTargetFunc, targetBeforeAction, action)
    local msg, conditionals = MMC.parseMsg(msg);
    
    -- trim leading and trailing white spaces
    msg = gsub(msg,"^%s*(.-)%s*$","%1");
    
    -- No conditionals. Just exit.
    if not conditionals then
        if not msg then
            return false;
        else
            if string.sub(msg, 1, 1) == "{" and string.sub(msg, -1) == "}" then
                return MMC.ExecuteMacroByName(string.sub(msg, 2, -2));
            end
            
            if hook then
                hook(msg);
            end
            return true;
        end
    end
    
    if conditionals.target == "mouseover" then
        if not UnitExists("mouseover") then
            conditionals.target = MMC.mouseoverUnit;
        end
        if not conditionals.target or (conditionals.target ~= "focus" and not UnitExists(conditionals.target)) then
            return false;
        end
    end
    
    local needRetarget = false;
    if fixEmptyTargetFunc then
        needRetarget = fixEmptyTargetFunc(conditionals, msg, hook)
    end
    
    MMC.SetHelp(conditionals);
    
    if conditionals.target == "focus" then
        if not MMC.TryTargetFocus() then
            return false;
        end
        conditionals.target = "target";
        needRetarget = true;
    end
    
    for k, v in pairs(conditionals) do
        if not MMC.Keywords[k] or not MMC.Keywords[k](conditionals) then
            if needRetarget then
                TargetLastTarget();
                needRetarget = false;
            end
            return false;
        end
    end
    
    if targetBeforeAction then
        if not UnitIsUnit("target", conditionals.target) then
            needRetarget = true;
        end
        
        TargetUnit(conditionals.target);
    else
        if needRetarget then
            TargetLastTarget();
            needRetarget = false;
        end
    end
    
    
    if string.sub(msg, 1, 1) == "{" and string.sub(msg, -1) == "}" then
        return MMC.ExecuteMacroByName(string.sub(msg, 2, -2));
    else
        action(msg);
    end
    
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
        if MMC.DoWithConditionals(v, MMC.Hooks.CAST_SlashCmd, MMC.FixEmptyTarget, true, CastSpellByName) then
            handled = true; -- we parsed at least one command
            break;
        end
    end
    return handled;
end

-- Attempts to target a unit by its name using a set of conditionals
-- msg: The raw message intercepted from a /target command
function MMC.DoTarget(msg)
    local handled = false;
    
    local action = function(msg)
        if string.sub(msg, 1, 1) == "@" then
            msg = UnitName(string.sub(msg, 2));
        end
        
        MMC.Hooks.TARGET_SlashCmd(msg);
    end
    
    for k, v in pairs(MMC.splitString(msg, ";%s*")) do
        if MMC.DoWithConditionals(v, MMC.Hooks.TARGET_SlashCmd, MMC.FixEmptyTargetSetTarget, false, action) then
            handled = true;
            break;
        end
    end
    return handled;
end

-- Attempts to attack a unit by a set of conditionals
-- msg: The raw message intercepted from a /petattack command
function MMC.DoPetAttack(msg)
    local handled = false;
    for k, v in pairs(MMC.splitString(msg, ";%s*")) do
        if MMC.DoWithConditionals(v, nil, MMC.FixEmptyTarget, true, PetAttack) then
            handled = true;
            break;
        end
    end
    return handled;
end

-- Searches for the given itemName in the player's iventory
-- itemName: The name of the item to look for
-- returns: The bag number and the slot number if the item has been found. nil otherwhise
function MMC.FindItem(itemName)
    MMCTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
    for i = 0, 4 do
        for j = 1, GetContainerNumSlots(i) do
            MMCTooltip:ClearLines();
            MMCTooltip:SetBagItem(i, j);
            if MMCTooltipTextLeft1:GetText() == itemName then
                return i, j;
            end
        end
    end
    
    for i = 0, 19 do
        MMCTooltip:ClearLines();
        hasItem = MMCTooltip:SetInventoryItem("player", i);
        
        if hasItem and MMCTooltipTextLeft1:GetText() == itemName then
            return -i;
        end
    end
end

-- Attempts to use or equip an item from the player's inventory by a  set of conditionals
-- msg: The raw message intercepted from a /use or /equip command
function MMC.DoUse(msg)
    local handled = false;
    
    local action = function(msg)
        local bag, slot = MMC.FindItem(msg);
        
        if bag and bag < 0 then
            return UseInventoryItem(-bag);
        end
        
        if not bag or not slot then
            return;
        end
        UseContainerItem(bag, slot);
    end
    
    for k, v in pairs(MMC.splitString(msg, ";%s*")) do
        if MMC.DoWithConditionals(v, action, MMC.FixEmptyTarget, true, action) then
            handled = true;
            break;
        end
    end
    return handled;
end

function MMC.DoEquipOffhand(msg)
    local handled = false;
    
    local action = function(msg)
        local bag, slot = MMC.FindItem(msg);
        if not bag or not slot then
            return;
        end
        PickupContainerItem(bag, slot);
        PickupInventoryItem(17);
    end
    
    for k, v in pairs(MMC.splitString(msg, ";%s*")) do
        if MMC.DoWithConditionals(v, action, MMC.FixEmptyTarget, true, action) then
            handled = true;
            break;
        end
    end
    return handled;
end

function MMC.DoUnshift(msg)
    local handled;
    
    local action = function(msg)
        local currentShapeshiftIndex = MMC.GetCurrentShapeshiftIndex();
        if currentShapeshiftIndex ~= 0 then
            CastShapeshiftForm(currentShapeshiftIndex);
        end
    end
    
    for k, v in pairs(MMC.splitString(msg, ";%s*")) do
        handled = false;
        if MMC.DoWithConditionals(v, action, MMC.FixEmptyTarget, true, action) then
            handled = true;
            break;
        end
    end
    
    if handled == nil then
        action();
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
    -- is the Auto Shot ability enabled
    autoShot = false,
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
MMC.Frame:RegisterEvent("START_AUTOREPEAT_SPELL");
MMC.Frame:RegisterEvent("STOP_AUTOREPEAT_SPELL");

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
    
    local hooks = {
        cast = { action = MMC.DoCast, },
        target = { action = MMC.DoTarget, },
        use = { action = MMC.DoUse, },
    };
    
    -- Hook SuperMacro's RunLine to stay compatible
    MMC.Hooks.RunLine = RunLine;
    MMC.RunLine = function(...)
        for i = 1, arg.n do
            local intercepted = false;
            local text = arg[i];
            
            for k,v in pairs(hooks) do
                local begin, _end = string.find(text, "^/"..k.."%s+[!%[]");
                if begin then
                    local msg = string.sub(text, _end);
                    v.action(msg);
                    intercepted = true;
                end
            end
            
            if not intercepted then
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

function MMC.Frame.START_AUTOREPEAT_SPELL(...)
    local _, className = UnitClass("player");
    if className == "HUNTER" then
        MMC.CurrentSpell.autoShot = true;
    end
end

function MMC.Frame.STOP_AUTOREPEAT_SPELL(...)
    local _, className = UnitClass("player");
    if className == "HUNTER" then
        MMC.CurrentSpell.autoShot = false;
    end
end

SLASH_PETATTACK1 = "/petattack";

SLASH_MMC1 = "/rl";

SLASH_USE1 = "/use";

SLASH_EQUIP1 = "/equip";

SLASH_EQUIPOH1 = "/equipoh";

SLASH_UNSHIFT1 = "/unshift";

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

MMC.Hooks.TARGET_SlashCmd = SlashCmdList["TARGET"];
MMC.TARGET_SlashCmd = function(msg)
    if MMC.DoTarget(msg) then
        return;
    end
    MMC.Hooks.TARGET_SlashCmd(msg);
end
SlashCmdList["TARGET"] = MMC.TARGET_SlashCmd;

SlashCmdList["PETATTACK"] = function(msg) MMC.DoPetAttack(msg); end

SlashCmdList["USE"] = MMC.DoUse;

SlashCmdList["EQUIP"] = MMC.DoUse;

SlashCmdList["EQUIPOH"] = MMC.DoEquipOffhand;

SlashCmdList["MMC"] = function() ReloadUI(); end

SlashCmdList["UNSHIFT"] = MMC.DoUnshift;