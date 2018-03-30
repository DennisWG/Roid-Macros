--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local Roids = _G.Roids or {}
Roids.mouseoverUnit = Roids.mouseoverUnit or nil;

local Extension = Roids.RegisterExtension("sRaidFrames");
Extension.RegisterEvent("ADDON_LOADED", "OnLoad");

function Extension:OnEnter(frame)
    Roids.mouseoverUnit = frame.unit;
end

function Extension.OnLoad()
    if arg1 ~= "sRaidFrames" then
        return;
    end
    
    Extension.HookMethod(sRaidFrames, "UnitTooltip", "OnEnter");
end

_G["Roids"] = Roids;