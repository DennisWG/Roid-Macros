--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0);
local MMC = _G.CastModifier or {};
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
    MMC.Localized.Attack = "Attack";
    MMC.Localized.AutoShot = "Auto Shot";
    MMC.Localized.Shoot = "Shoot";
    
    MMC.Localized.CreatureTypes = {
        ["Beast"] = "Beast",
        ["Critter"] = "Critter",
        ["Demon"] = "Demon",
        ["Dragonkin"] = "Dragonkin",
        ["Elemental"] = "Elemental",
        ["Giant"] = "Giant",
        ["Humanoid"] = "Humanoid",
        ["Mechanical"] = "Mechanical",
        ["Not specified"] = "Not specified",
        ["Totem"] = "Totem",
        ["Undead"] = "Undead",
    };
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
    MMC.Localized.Attack = "Attack";
    MMC.Localized.AutoShot = "Auto Shot";
    MMC.Localized.Shoot = "Shoot";
    
    MMC.Localized.CreatureTypes = {
        ["Wildtier"] = "Beast",
        ["Kleintier"] = "Critter",
        ["Dämon"] = "Demon",
        ["Drachkin"] = "Dragonkin",
        ["Elementar"] = "Elemental",
        ["Riese"] = "Giant",
        ["Humanoid"] = "Humanoid",
        ["Mechanisch"] = "Mechanical",
        ["Nicht spezifiziert"] = "Not specified",
        ["Totem"] = "Totem",
        ["Untoter"] = "Undead",
    };
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
    MMC.Localized.Attack = "Attack";
    MMC.Localized.AutoShot = "Auto Shot";
    MMC.Localized.Shoot = "Shoot";
    
    MMC.Localized.CreatureTypes = {
        ["Bête"] = "Beast",
        ["Bestiole"] = "Critter",
        ["Démon"] = "Demon",
        ["Draconien"] = "Dragonkin",
        ["Elémentaire"] = "Elemental",
        ["Géant"] = "Giant",
        ["Humanoïde"] = "Humanoid",
        ["Machine"] = "Mechanical",
        ["Non spécifié"] = "Not specified",
        ["Totem"] = "Totem",
        ["Mort-vivant"] = "Undead",
    };
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
    MMC.Localized.Attack = "Attack";
    MMC.Localized.AutoShot = "Auto Shot";
    MMC.Localized.Shoot = "Shoot";
    
    MMC.Localized.CreatureTypes = {
        ["야수"] = "Beast",
        ["동물"] = "Critter",
        ["악마"] = "Demon",
        ["용족"] = "Dragonkin",
        ["정령"] = "Elemental",
        ["거인"] = "Giant",
        ["인간형"] = "Humanoid",
        ["기계"] = "Mechanical",
        ["기타"] = "Not specified",
        ["토템"] = "Totem",
        ["언데드"] = "Undead",
    };
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
    MMC.Localized.Attack = "Attack";
    MMC.Localized.AutoShot = "Auto Shot";
    MMC.Localized.Shoot = "Shoot";
    
    MMC.Localized.CreatureTypes = {
        ["野兽"] = "Beast",
        ["小动物"] = "Critter",
        ["恶魔"] = "Demon",
        ["龙类"] = "Dragonkin",
        ["元素生物"] = "Elemental",
        ["巨人"] = "Giant",
        ["人型生物"] = "Humanoid",
        ["机械"] = "Mechanical",
        ["未指定"] = "Not specified",
        ["图腾"] = "Totem",
        ["亡灵"] = "Undead",
    };
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
    MMC.Localized.Attack = "Attack";
    MMC.Localized.AutoShot = "Auto Shot";
    MMC.Localized.Shoot = "Shoot";
    
    MMC.Localized.CreatureTypes = {
        ["野獸"] = "Beast",
        ["小動物"] = "Critter",
        ["惡魔"] = "Demon",
        ["龍類"] = "Dragonkin",
        ["元素生物"] = "Elemental",
        ["巨人"] = "Giant",
        ["人型生物"] = "Humanoid",
        ["機械"] = "Mechanical",
        ["不明"] = "Not specified",
        ["圖騰"] = "Totem",
        ["不死族"] = "Undead",
    };
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
    MMC.Localized.Attack = "Attack";
    MMC.Localized.AutoShot = "Auto Shot";
    MMC.Localized.Shoot = "Shoot";
    
    MMC.Localized.CreatureTypes = {
        ["Животное"] = "Beast",
        ["Существо"] = "Critter",
        ["Демон"] = "Demon",
        ["Дракон"] = "Dragonkin",
        ["Элементаль"] = "Elemental",
        ["Великан"] = "Giant",
        ["Гуманоид"] = "Humanoid",
        ["Механизм"] = "Mechanical",
        ["Не указано"] = "Not specified",
        ["Тотем"] = "Totem",
        ["Нежить"] = "Undead",
    };
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
    MMC.Localized.Attack = "Attack";
    MMC.Localized.AutoShot = "Auto Shot";
    MMC.Localized.Shoot = "Shoot";
    
    MMC.Localized.CreatureTypes = {
        ["Bestia"] = "Beast",
        ["Alma"] = "Critter",
        ["Demonio"] = "Demon",
        ["Dragon"] = "Dragonkin",
        ["Elemental"] = "Elemental",
        ["Gigante"] = "Giant",
        ["Humanoide"] = "Humanoid",
        ["Mecánico"] = "Mechanical",
        ["No especificado"] = "Not specified",
        ["Tótem"] = "Totem",
        ["No-muerto"] = "Undead",
    };
end

_G["CastModifier"] = MMC;