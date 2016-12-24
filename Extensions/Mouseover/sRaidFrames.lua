--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local MMC = _G.CastModifier or {}
MMC.mouseoverUnit = MMC.mouseoverUnit or nil;

local Extension = MMC.RegisterExtension("sRaidFrames");
Extension.RegisterEvent("ADDON_LOADED", "OnLoad");

function Extension:OnEnter(frame)
    MMC.mouseoverUnit = frame.unit;
end

function Extension.OnLoad()
    if arg1 ~= "sRaidFrames" then
        return;
    end
    
    Extension.HookMethod(sRaidFrames, "UnitTooltip", "OnEnter");
end

_G["CastModifier"] = MMC;