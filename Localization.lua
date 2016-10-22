--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local MMC = _G.CastModifier or {} -- redundant since we're loading first but peace of mind if another file is added top of chain
MMC.Locale = GetLocale();
MMC.Localized = {};

if MMC.Locale == "enUS" or MMC.Locale == "enGB" then
    MMC.Localized.Shield = "Shield";
    MMC.Localized.Bow = "Bow";
    MMC.Localized.Crossbow = "Crossbow";
    MMC.Localized.Gun = "Gun";
    MMC.Localized.Thrown = "Thrown";
    MMC.Localized.Wand = "Wand";
    MMC.Localized.Sword = "Sword";
    MMC.Localized.Staff = "Staff";
    MMC.Localized.Polearm = "Polearm";
    MMC.Localized.Mace = "Mace";
    MMC.Localized.FistWeapon = "Fist Weapon";
    MMC.Localized.Dagger = "Dagger";
    MMC.Localized.Axe = "Axe";
elseif MMC.Locale == "deDE" then
    MMC.Localized.Shield = "Shield";
    MMC.Localized.Bow = "Bow";
    MMC.Localized.Crossbow = "Crossbow";
    MMC.Localized.Gun = "Gun";
    MMC.Localized.Thrown = "Thrown";
    MMC.Localized.Wand = "Wand";
    MMC.Localized.Sword = "Sword";
    MMC.Localized.Staff = "Staff";
    MMC.Localized.Polearm = "Polearm";
    MMC.Localized.Mace = "Mace";
    MMC.Localized.FistWeapon = "Fist Weapon";
    MMC.Localized.Dagger = "Dagger";
    MMC.Localized.Axe = "Axe";
elseif MMC.Locale == "frFR" then
    MMC.Localized.Shield = "Shield";
    MMC.Localized.Bow = "Bow";
    MMC.Localized.Crossbow = "Crossbow";
    MMC.Localized.Gun = "Gun";
    MMC.Localized.Thrown = "Thrown";
    MMC.Localized.Wand = "Wand";
    MMC.Localized.Sword = "Sword";
    MMC.Localized.Staff = "Staff";
    MMC.Localized.Polearm = "Polearm";
    MMC.Localized.Mace = "Mace";
    MMC.Localized.FistWeapon = "Fist Weapon";
    MMC.Localized.Dagger = "Dagger";
    MMC.Localized.Axe = "Axe";
elseif MMC.Locale == "koKR" then
    MMC.Localized.Shield = "Shield";
    MMC.Localized.Bow = "Bow";
    MMC.Localized.Crossbow = "Crossbow";
    MMC.Localized.Gun = "Gun";
    MMC.Localized.Thrown = "Thrown";
    MMC.Localized.Wand = "Wand";
    MMC.Localized.Sword = "Sword";
    MMC.Localized.Staff = "Staff";
    MMC.Localized.Polearm = "Polearm";
    MMC.Localized.Mace = "Mace";
    MMC.Localized.FistWeapon = "Fist Weapon";
    MMC.Localized.Dagger = "Dagger";
    MMC.Localized.Axe = "Axe";
elseif MMC.Locale == "zhCN" then
    MMC.Localized.Shield = "Shield";
    MMC.Localized.Bow = "Bow";
    MMC.Localized.Crossbow = "Crossbow";
    MMC.Localized.Gun = "Gun";
    MMC.Localized.Thrown = "Thrown";
    MMC.Localized.Wand = "Wand";
    MMC.Localized.Sword = "Sword";
    MMC.Localized.Staff = "Staff";
    MMC.Localized.Polearm = "Polearm";
    MMC.Localized.Mace = "Mace";
    MMC.Localized.FistWeapon = "Fist Weapon";
    MMC.Localized.Dagger = "Dagger";
    MMC.Localized.Axe = "Axe";
elseif MMC.Locale == "zhTW" then
    MMC.Localized.Shield = "Shield";
    MMC.Localized.Bow = "Bow";
    MMC.Localized.Crossbow = "Crossbow";
    MMC.Localized.Gun = "Gun";
    MMC.Localized.Thrown = "Thrown";
    MMC.Localized.Wand = "Wand";
    MMC.Localized.Sword = "Sword";
    MMC.Localized.Staff = "Staff";
    MMC.Localized.Polearm = "Polearm";
    MMC.Localized.Mace = "Mace";
    MMC.Localized.FistWeapon = "Fist Weapon";
    MMC.Localized.Dagger = "Dagger";
    MMC.Localized.Axe = "Axe";
elseif MMC.Locale == "ruRU" then
    MMC.Localized.Shield = "Shield";
    MMC.Localized.Bow = "Bow";
    MMC.Localized.Crossbow = "Crossbow";
    MMC.Localized.Gun = "Gun";
    MMC.Localized.Thrown = "Thrown";
    MMC.Localized.Wand = "Wand";
    MMC.Localized.Sword = "Sword";
    MMC.Localized.Staff = "Staff";
    MMC.Localized.Polearm = "Polearm";
    MMC.Localized.Mace = "Mace";
    MMC.Localized.FistWeapon = "Fist Weapon";
    MMC.Localized.Dagger = "Dagger";
    MMC.Localized.Axe = "Axe";
elseif MMC.Locale == "esES" then
    MMC.Localized.Shield = "Shield";
    MMC.Localized.Bow = "Bow";
    MMC.Localized.Crossbow = "Crossbow";
    MMC.Localized.Gun = "Gun";
    MMC.Localized.Thrown = "Thrown";
    MMC.Localized.Wand = "Wand";
    MMC.Localized.Sword = "Sword";
    MMC.Localized.Staff = "Staff";
    MMC.Localized.Polearm = "Polearm";
    MMC.Localized.Mace = "Mace";
    MMC.Localized.FistWeapon = "Fist Weapon";
    MMC.Localized.Dagger = "Dagger";
    MMC.Localized.Axe = "Axe";
end

_G["CastModifier"] = MMC