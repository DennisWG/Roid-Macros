--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local MMC = _G.CastModifier or {}
MMC.mouseoverUnit = MMC.mouseoverUnit or nil;

local Extension = MMC.RegisterExtension("BlizzardPartyFrame");

function Extension.SetUnit(_, unit)
    MMC.mouseoverUnit = unit;
end


function Extension.OnClose()
    MMC.mouseoverUnit = nil;
end

function Extension.OnLoad()
    Extension.HookMethod(_G["GameTooltip"], "SetUnit", "SetUnit");
    Extension.HookMethod(_G["GameTooltip"], "Hide", "OnClose");
    Extension.HookMethod(_G["GameTooltip"], "FadeOut", "OnClose");
end

_G["CastModifier"] = MMC;