--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local MMC = _G.CastModifier or {}

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