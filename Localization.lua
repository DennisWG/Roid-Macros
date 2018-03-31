--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0);
local Roids = _G.Roids or {};
Roids.Locale = GetLocale();
Roids.Localized = {};

if Roids.Locale == "enUS" or Roids.Locale == "enGB" then
    Roids.Localized.Shield = "Shield";
    Roids.Localized.Bow = "Bow";
    Roids.Localized.Crossbow = "Crossbow";
    Roids.Localized.Gun = "Gun";
    Roids.Localized.Thrown = "Thrown";
    Roids.Localized.Wand = "Wand";
    Roids.Localized.Sword = "Sword";
    Roids.Localized.Staff = "Staff";
    Roids.Localized.Polearm = "Polearm";
    Roids.Localized.Mace = "Mace";
    Roids.Localized.FistWeapon = "Fist Weapon";
    Roids.Localized.Dagger = "Dagger";
    Roids.Localized.Axe = "Axe";
    Roids.Localized.Attack = "Attack";
    Roids.Localized.AutoShot = "Auto Shot";
    Roids.Localized.Shoot = "Shoot";
    Roids.Localized.SpellRank = "%(Rank %d+%)";
    
    Roids.Localized.CreatureTypes = {
        ["Beast"] = "Beast",
        ["Critter"] = "Critter",
        ["Demon"] = "Demon",
        ["Dragonkin"] = "Dragonkin",
        ["Elemental"] = "Elemental",
        ["Giant"] = "Giant",
        ["Humanoid"] = "Humanoid",
        ["Mechanical"] = "Mechanical",
        ["Not specified"] = "Not_Specified",
        ["Totem"] = "Totem",
        ["Undead"] = "Undead",
    };
elseif Roids.Locale == "deDE" then
    Roids.Localized.Shield = "Shield";
    Roids.Localized.Bow = "Bow";
    Roids.Localized.Crossbow = "Crossbow";
    Roids.Localized.Gun = "Gun";
    Roids.Localized.Thrown = "Thrown";
    Roids.Localized.Wand = "Wand";
    Roids.Localized.Sword = "Sword";
    Roids.Localized.Staff = "Staff";
    Roids.Localized.Polearm = "Polearm";
    Roids.Localized.Mace = "Mace";
    Roids.Localized.FistWeapon = "Fist Weapon";
    Roids.Localized.Dagger = "Dagger";
    Roids.Localized.Axe = "Axe";
    Roids.Localized.Attack = "Attack";
    Roids.Localized.AutoShot = "Auto Shot";
    Roids.Localized.Shoot = "Shoot";
    Roids.Localized.SpellRank = "%(Rank %d+%)";
    
    Roids.Localized.CreatureTypes = {
        ["Wildtier"] = "Beast",
        ["Kleintier"] = "Critter",
        ["Dämon"] = "Demon",
        ["Drachkin"] = "Dragonkin",
        ["Elementar"] = "Elemental",
        ["Riese"] = "Giant",
        ["Humanoid"] = "Humanoid",
        ["Mechanisch"] = "Mechanical",
        ["Nicht spezifiziert"] = "Not_Specified",
        ["Totem"] = "Totem",
        ["Untoter"] = "Undead",
    };
elseif Roids.Locale == "frFR" then
    Roids.Localized.Shield = "Shield";
    Roids.Localized.Bow = "Bow";
    Roids.Localized.Crossbow = "Crossbow";
    Roids.Localized.Gun = "Gun";
    Roids.Localized.Thrown = "Thrown";
    Roids.Localized.Wand = "Wand";
    Roids.Localized.Sword = "Sword";
    Roids.Localized.Staff = "Staff";
    Roids.Localized.Polearm = "Polearm";
    Roids.Localized.Mace = "Mace";
    Roids.Localized.FistWeapon = "Fist Weapon";
    Roids.Localized.Dagger = "Dagger";
    Roids.Localized.Axe = "Axe";
    Roids.Localized.Attack = "Attack";
    Roids.Localized.AutoShot = "Auto Shot";
    Roids.Localized.Shoot = "Shoot";
    Roids.Localized.SpellRank = "%(Rank %d+%)";
    
    Roids.Localized.CreatureTypes = {
        ["Bête"] = "Beast",
        ["Bestiole"] = "Critter",
        ["Démon"] = "Demon",
        ["Draconien"] = "Dragonkin",
        ["Elémentaire"] = "Elemental",
        ["Géant"] = "Giant",
        ["Humanoïde"] = "Humanoid",
        ["Machine"] = "Mechanical",
        ["Non spécifié"] = "Not_Specified",
        ["Totem"] = "Totem",
        ["Mort-vivant"] = "Undead",
    };
elseif Roids.Locale == "koKR" then
    Roids.Localized.Shield = "Shield";
    Roids.Localized.Bow = "Bow";
    Roids.Localized.Crossbow = "Crossbow";
    Roids.Localized.Gun = "Gun";
    Roids.Localized.Thrown = "Thrown";
    Roids.Localized.Wand = "Wand";
    Roids.Localized.Sword = "Sword";
    Roids.Localized.Staff = "Staff";
    Roids.Localized.Polearm = "Polearm";
    Roids.Localized.Mace = "Mace";
    Roids.Localized.FistWeapon = "Fist Weapon";
    Roids.Localized.Dagger = "Dagger";
    Roids.Localized.Axe = "Axe";
    Roids.Localized.Attack = "Attack";
    Roids.Localized.AutoShot = "Auto Shot";
    Roids.Localized.Shoot = "Shoot";
    Roids.Localized.SpellRank = "%(Rank %d+%)";
    
    Roids.Localized.CreatureTypes = {
        ["야수"] = "Beast",
        ["동물"] = "Critter",
        ["악마"] = "Demon",
        ["용족"] = "Dragonkin",
        ["정령"] = "Elemental",
        ["거인"] = "Giant",
        ["인간형"] = "Humanoid",
        ["기계"] = "Mechanical",
        ["기타"] = "Not_Specified",
        ["토템"] = "Totem",
        ["언데드"] = "Undead",
    };
elseif Roids.Locale == "zhCN" then
    Roids.Localized.Shield = "Shield";
    Roids.Localized.Bow = "Bow";
    Roids.Localized.Crossbow = "Crossbow";
    Roids.Localized.Gun = "Gun";
    Roids.Localized.Thrown = "Thrown";
    Roids.Localized.Wand = "Wand";
    Roids.Localized.Sword = "Sword";
    Roids.Localized.Staff = "Staff";
    Roids.Localized.Polearm = "Polearm";
    Roids.Localized.Mace = "Mace";
    Roids.Localized.FistWeapon = "Fist Weapon";
    Roids.Localized.Dagger = "Dagger";
    Roids.Localized.Axe = "Axe";
    Roids.Localized.Attack = "Attack";
    Roids.Localized.AutoShot = "Auto Shot";
    Roids.Localized.Shoot = "Shoot";
    Roids.Localized.SpellRank = "%(Rank %d+%)";
    
    Roids.Localized.CreatureTypes = {
        ["野兽"] = "Beast",
        ["小动物"] = "Critter",
        ["恶魔"] = "Demon",
        ["龙类"] = "Dragonkin",
        ["元素生物"] = "Elemental",
        ["巨人"] = "Giant",
        ["人型生物"] = "Humanoid",
        ["机械"] = "Mechanical",
        ["未指定"] = "Not_Specified",
        ["图腾"] = "Totem",
        ["亡灵"] = "Undead",
    };
elseif Roids.Locale == "zhTW" then
    Roids.Localized.Shield = "Shield";
    Roids.Localized.Bow = "Bow";
    Roids.Localized.Crossbow = "Crossbow";
    Roids.Localized.Gun = "Gun";
    Roids.Localized.Thrown = "Thrown";
    Roids.Localized.Wand = "Wand";
    Roids.Localized.Sword = "Sword";
    Roids.Localized.Staff = "Staff";
    Roids.Localized.Polearm = "Polearm";
    Roids.Localized.Mace = "Mace";
    Roids.Localized.FistWeapon = "Fist Weapon";
    Roids.Localized.Dagger = "Dagger";
    Roids.Localized.Axe = "Axe";
    Roids.Localized.Attack = "Attack";
    Roids.Localized.AutoShot = "Auto Shot";
    Roids.Localized.Shoot = "Shoot";
    Roids.Localized.SpellRank = "%(Rank %d+%)";
    
    Roids.Localized.CreatureTypes = {
        ["野獸"] = "Beast",
        ["小動物"] = "Critter",
        ["惡魔"] = "Demon",
        ["龍類"] = "Dragonkin",
        ["元素生物"] = "Elemental",
        ["巨人"] = "Giant",
        ["人型生物"] = "Humanoid",
        ["機械"] = "Mechanical",
        ["不明"] = "Not_Specified",
        ["圖騰"] = "Totem",
        ["不死族"] = "Undead",
    };
elseif Roids.Locale == "ruRU" then
    Roids.Localized.Shield = "Shield";
    Roids.Localized.Bow = "Bow";
    Roids.Localized.Crossbow = "Crossbow";
    Roids.Localized.Gun = "Gun";
    Roids.Localized.Thrown = "Thrown";
    Roids.Localized.Wand = "Wand";
    Roids.Localized.Sword = "Sword";
    Roids.Localized.Staff = "Staff";
    Roids.Localized.Polearm = "Polearm";
    Roids.Localized.Mace = "Mace";
    Roids.Localized.FistWeapon = "Fist Weapon";
    Roids.Localized.Dagger = "Dagger";
    Roids.Localized.Axe = "Axe";
    Roids.Localized.Attack = "Attack";
    Roids.Localized.AutoShot = "Auto Shot";
    Roids.Localized.Shoot = "Shoot";
    Roids.Localized.SpellRank = "%(Rank %d+%)";
    
    Roids.Localized.CreatureTypes = {
        ["Животное"] = "Beast",
        ["Существо"] = "Critter",
        ["Демон"] = "Demon",
        ["Дракон"] = "Dragonkin",
        ["Элементаль"] = "Elemental",
        ["Великан"] = "Giant",
        ["Гуманоид"] = "Humanoid",
        ["Механизм"] = "Mechanical",
        ["Не указано"] = "Not_Specified",
        ["Тотем"] = "Totem",
        ["Нежить"] = "Undead",
    };
elseif Roids.Locale == "esES" then
    Roids.Localized.Shield = "Shield";
    Roids.Localized.Bow = "Bow";
    Roids.Localized.Crossbow = "Crossbow";
    Roids.Localized.Gun = "Gun";
    Roids.Localized.Thrown = "Thrown";
    Roids.Localized.Wand = "Wand";
    Roids.Localized.Sword = "Sword";
    Roids.Localized.Staff = "Staff";
    Roids.Localized.Polearm = "Polearm";
    Roids.Localized.Mace = "Mace";
    Roids.Localized.FistWeapon = "Fist Weapon";
    Roids.Localized.Dagger = "Dagger";
    Roids.Localized.Axe = "Axe";
    Roids.Localized.Attack = "Attack";
    Roids.Localized.AutoShot = "Auto Shot";
    Roids.Localized.Shoot = "Shoot";
    Roids.Localized.SpellRank = "%(Rank %d+%)";
    
    Roids.Localized.CreatureTypes = {
        ["Bestia"] = "Beast",
        ["Alma"] = "Critter",
        ["Demonio"] = "Demon",
        ["Dragon"] = "Dragonkin",
        ["Elemental"] = "Elemental",
        ["Gigante"] = "Giant",
        ["Humanoide"] = "Humanoid",
        ["Mecánico"] = "Mechanical",
        ["No especificado"] = "Not_Specified",
        ["Tótem"] = "Totem",
        ["No-muerto"] = "Undead",
    };
end

_G["Roids"] = Roids;