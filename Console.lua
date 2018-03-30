--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local Roids = _G.Roids or {}

SLASH_PETATTACK1 = "/petattack";

SLASH_RELOAD1 = "/rl";

SLASH_USE1 = "/use";

SLASH_EQUIP1 = "/equip";

SLASH_EQUIPOH1 = "/equipoh";

SLASH_UNSHIFT1 = "/unshift";

Roids.Hooks.CAST_SlashCmd = SlashCmdList["CAST"];
Roids.CAST_SlashCmd = function(msg)
    -- get in there first, i.e do a PreHook
    if Roids.DoCast(msg) then
        return;
    end
    -- if there was nothing for us to handle pass it to the original
    Roids.Hooks.CAST_SlashCmd(msg);
end

SlashCmdList["CAST"] = Roids.CAST_SlashCmd;

Roids.Hooks.TARGET_SlashCmd = SlashCmdList["TARGET"];
Roids.TARGET_SlashCmd = function(msg)
    if Roids.DoTarget(msg) then
        return;
    end
    Roids.Hooks.TARGET_SlashCmd(msg);
end
SlashCmdList["TARGET"] = Roids.TARGET_SlashCmd;

SlashCmdList["PETATTACK"] = function(msg) Roids.DoPetAttack(msg); end

SlashCmdList["USE"] = Roids.DoUse;

SlashCmdList["EQUIP"] = Roids.DoUse;

SlashCmdList["EQUIPOH"] = Roids.DoEquipOffhand;

SlashCmdList["RELOAD"] = function() ReloadUI(); end

SlashCmdList["UNSHIFT"] = Roids.DoUnshift;