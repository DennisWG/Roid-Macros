--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local Roids = _G.Roids or {}

-- Validates that the given target is either friend (if [help]) or foe (if [harm])
-- target: The unit id to check
-- help: Optional. If set to 1 then the target must be friendly. If set to 0 it must be an enemy.
-- remarks: Will always return true if help is not given
-- returns: Whether or not the given target can either be attacked or supported, depending on help
function Roids.CheckHelp(target, help)
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
function Roids.IsValidTarget(target, help)    
	if target ~= "mouseover" then
		if not Roids.CheckHelp(target, help) or not UnitExists(target) then
			return false;
		end
		return true;
	end
	
	if (not Roids.mouseoverUnit) and not UnitName("mouseover") then
		return false;
	end
    
	return Roids.CheckHelp(target, help);
end

-- Returns the current shapeshift / stance index
-- returns: The index of the current shapeshift form / stance. 0 if in no shapeshift form / stance
function Roids.GetCurrentShapeshiftIndex()
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
function Roids.HasBuffName(buffName, unit)
    if not buffName or not unit then
        return false;
    end
    
    local text = getglobal(RoidsTooltip:GetName().."TextLeft1");
	for i=1, 32 do
		RoidsTooltip:SetOwner(UIParent, "ANCHOR_NONE");
		RoidsTooltip:SetUnitBuff(unit, i);
		name = text:GetText();
		RoidsTooltip:Hide();
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
function Roids.HasDeBuffName(buffName, unit)
    if not buffName or not unit then
        return false;
    end
    
    local text = getglobal(RoidsTooltip:GetName().."TextLeft1");
	for i=1, 16 do
		RoidsTooltip:SetOwner(UIParent, "ANCHOR_NONE");
		RoidsTooltip:SetUnitDebuff(unit, i);
		name = text:GetText();
		RoidsTooltip:Hide();
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
function Roids.HasBuff(textureName)
    for i = 1, 16 do
        if UnitBuff("player", i) == textureName then
            return true;
        end
    end
    
    return false;
end

-- Maps easy to use weapon type names (e.g. Axes, Shields) to their inventory slot name and their localized tooltip name
Roids.WeaponTypeNames = {
    Daggers = { slot = "MainHandSlot", name = Roids.Localized.Dagger },
    Fists =  { slot = "MainHandSlot", name = Roids.Localized.FistWeapon },
    Axes =  { slot = "MainHandSlot", name = Roids.Localized.Axe },
    Swords =  { slot = "MainHandSlot", name = Roids.Localized.Sword },
    Staffs =  { slot = "MainHandSlot", name = Roids.Localized.Staff },
    Maces =  { slot = "MainHandSlot", name = Roids.Localized.Mace },
    Polearms =  { slot = "MainHandSlot", name = Roids.Localized.Polearm },
    Shields = { slot = "SecondaryHandSlot", name = Roids.Localized.Shield },
    Guns = { slot = "RangedSlot", name = Roids.Localized.Gun },
    Crossbows = { slot = "RangedSlot", name = Roids.Localized.Crossbow },
    Bows = { slot = "RangedSlot", name = Roids.Localized.Bow },
    Thrown = { slot = "RangedSlot", name = Roids.Localized.Thrown },
    Wands = { slot = "RangedSlot", name = Roids.Localized.Wand },
};

-- Checks whether or not the given weaponType is currently equipped
-- weaponType: The name of the weapon's type (e.g. Axe, Shield, etc.)
-- returns: True when equipped, otherwhise false
function Roids.HasWeaponEquipped(weaponType)
    if not Roids.WeaponTypeNames[weaponType] then
        return false;
    end
    
	RoidsTooltip:SetOwner(UIParent, "ANCHOR_NONE");
    
    local slotName = Roids.WeaponTypeNames[weaponType].slot;
    local localizedName = Roids.WeaponTypeNames[weaponType].name;

    local slotId = GetInventorySlotInfo(slotName);
    hasItem = RoidsTooltip:SetInventoryItem("player", slotId);
    if not hasItem then
        return false;
    end
    
	local lines = RoidsTooltip:NumLines();
	for i = 1, lines do
		local label = getglobal("RoidsTooltipTextLeft"..i);
		if label:GetText() then
			if label:GetText() == localizedName then
                return true;
            end
		end
        
		label = getglobal("RoidsTooltipTextRight"..i);
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
function Roids.IsTargetInGroupType(target, groupType)
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
function Roids.CheckChanneled(conditionals)
    -- Remove the "(Rank X)" part from the spells name in order to allow downranking
    local spellName = string.gsub(Roids.CurrentSpell.spellName, "%(.-%)%s*", "");
    local channeled = string.gsub(conditionals.checkchanneled, "%(.-%)%s*", "");
    
    if Roids.CurrentSpell.type == "channeled" and spellName == channeled then
        return false;
    end
    
    if channeled == Roids.Localized.Attack then
        return not Roids.CurrentSpell.autoAttack;
    end
    
    if channeled == Roids.Localized.AutoShot then
        return not Roids.CurrentSpell.autoShot;
    end
    
    if channeled == Roids.Localized.Shoot then
        return not Roids.CurrentSpell.wand;
    end
    
    Roids.CurrentSpell.spellName = channeled;
    return true;
end

-- Checks whether or not the given unit has more or less power in percent than the given amount
-- unit: The unit we're checking
-- bigger: 1 if the percentage needs to be bigger, 0 if it needs to be lower
-- amount: The required amount
-- returns: True or false
function Roids.ValidatePower(unit, bigger, amount)
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
function Roids.ValidateRawPower(unit, bigger, amount)
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
function Roids.ValidateHp(unit, bigger, amount)
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
function Roids.ValidateCreatureType(creatureType, target)
    local targetType = UnitCreatureType(target);
    local englishType = Roids.Localized.CreatureTypes[targetType];
    return creatureType == targetType or creatureType == englishType;
end

-- Returns the cooldown of the given spellName or nil if no such spell was found
function Roids.GetSpellCooldownByName(spellName)
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
function Roids.GetInventoryCooldownByName(itemName)
    RoidsTooltip:SetOwner(UIParent, "ANCHOR_NONE");
    for i=0, 19 do
        RoidsTooltip:ClearLines();
        hasItem = RoidsTooltip:SetInventoryItem("player", i);
        
        if hasItem then
            local lines = RoidsTooltip:NumLines();
            
            local label = getglobal("RoidsTooltipTextLeft1");
            
            if label:GetText() == itemName then
                local _, duration, _ = GetInventoryItemCooldown("player", i);
                return duration;
            end
        end
    end
    
    return nil;
end

-- Returns the cooldown of the given itemName in the player's bags or nil if no such item was found
function Roids.GetContainerItemCooldownByName(itemName)
    RoidsTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
    
    for i = 0, 4 do
        for j = 1, GetContainerNumSlots(i) do
            RoidsTooltip:ClearLines();
            RoidsTooltip:SetBagItem(i, j);
            if RoidsTooltipTextLeft1:GetText() == itemName then
                local _, duration, _ = GetContainerItemCooldown(i, j);
                return duration;
            end
        end
    end
    
    return nil;
end

-- A list of Conditionals and their functions to validate them
Roids.Keywords = {
    help = function(conditionals)
        return true;
    end,
    
    harm = function(conditionals)
        return true;
    end,
    
    stance = function(conditionals)
        local inStance = false;
        for k,v in pairs(Roids.splitString(conditionals.stance, "/")) do
            if Roids.GetCurrentShapeshiftIndex() == tonumber(v) then
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
        
        for k,v in pairs(Roids.splitString(conditionals.mod, "/")) do
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
        return Roids.IsValidTarget(conditionals.target, conditionals.help);
    end,
    
    combat = function(conditionals)
        return UnitAffectingCombat("player");
    end,
    
    nocombat = function(conditionals)
        return not UnitAffectingCombat("player");
    end,
    
    stealth = function(conditionals)
        return Roids.HasBuff("Interface\\Icons\\Ability_Ambush");
    end,
    
    nostealth = function(conditionals)
        return not Roids.HasBuff("Interface\\Icons\\Ability_Ambush");
    end,
    
    equipped = function(conditionals)
        return Roids.HasWeaponEquipped(conditionals.equipped);
    end,
    
    dead = function(conditionals)
        return UnitIsDeadOrGhost(conditionals.target);
    end,
    
    nodead = function(conditionals)
        return not UnitIsDeadOrGhost(conditionals.target);
    end,
    
    party = function(conditionals)
        return Roids.IsTargetInGroupType(conditionals.target, "party");
    end,
    
    raid = function(conditionals)
        return Roids.IsTargetInGroupType(conditionals.target, "raid");
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
        return Roids.CheckChanneled(conditionals);
    end,
    
    buff = function(conditionals)
        return Roids.HasBuffName(conditionals.buff, conditionals.target);
    end,
    
    nobuff = function(conditionals)
        return not Roids.HasBuffName(conditionals.nobuff, conditionals.target);
    end,
    
    debuff = function(conditionals)
        return Roids.HasDeBuffName(conditionals.debuff, conditionals.target);
    end,
    
    nodebuff = function(conditionals)
        return not Roids.HasDeBuffName(conditionals.nodebuff, conditionals.target);
    end,
    
    mybuff = function(conditionals)
        return Roids.HasBuffName(conditionals.mybuff, "player");
    end,
    
    nomybuff = function(conditionals)
        return not Roids.HasBuffName(conditionals.nomybuff, "player");
    end,
    
    mydebuff = function(conditionals)
        return Roids.HasDeBuffName(conditionals.mydebuff, "player");
    end,
    
    nomydebuff = function(conditionals)
        return not Roids.HasDeBuffName(conditionals.nomydebuff, "player");
    end,
    
    power = function(conditionals)
        return Roids.ValidatePower(conditionals.target, conditionals.power.bigger, conditionals.power.amount);
    end,
    
    mypower = function(conditionals)
        return Roids.ValidatePower("player", conditionals.mypower.bigger, conditionals.mypower.amount);
    end,
    
    rawpower = function(conditionals)
        return Roids.ValidateRawPower(conditionals.target, conditionals.rawpower.bigger, conditionals.rawpower.amount);
    end,
    
    myrawpower = function(conditionals)
        return Roids.ValidateRawPower("player", conditionals.myrawpower.bigger, conditionals.myrawpower.amount);
    end,
    
    hp = function(conditionals)
        return Roids.ValidateHp(conditionals.target, conditionals.hp.bigger, conditionals.hp.amount);
    end,
    
    myhp = function(conditionals)
        return Roids.ValidateHp("player", conditionals.myhp.bigger, conditionals.myhp.amount);
    end,
    
    type = function(conditionals)
        return Roids.ValidateCreatureType(conditionals.type, conditionals.target);
    end,
    
    cooldown = function(conditionals)
        local name = string.gsub(conditionals.cooldown, "_", " ");
        local cd = Roids.GetSpellCooldownByName(name);
        if not cd then cd = Roids.GetInventoryCooldownByName(name); end
        if not cd then cd = Roids.GetContainerItemCooldownByName(name) end
        return cd > 0;
    end,
    
    nocooldown = function(conditionals)
        local name = string.gsub(conditionals.nocooldown, "_", " ");
        local cd = Roids.GetSpellCooldownByName(name);
        if not cd then cd = Roids.GetInventoryCooldownByName(name); end
        if not cd then cd = Roids.GetContainerItemCooldownByName(name) end
        return cd == 0;
    end,
    
    channeled = function(conditionals)
        return Roids.CurrentSpell.spellName ~= "";
    end,
    
    nochanneled = function(conditionals)
        return Roids.CurrentSpell.spellName == "";
    end,
    
    attacks = function(conditionals)
        return UnitIsUnit("targettarget", conditionals.attacks);
    end,
    
    noattacks = function(conditionals)
        return not UnitIsUnit("targettarget", conditionals.noattacks);
    end,
    
    isplayer = function(conditionals)
        return UnitIsPlayer(conditionals.isplayer);
    end,
    
    isnpc = function(conditionals)
        return not UnitIsPlayer(conditionals.isnpc);
    end,
};