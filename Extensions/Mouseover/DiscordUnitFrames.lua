--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local MMC = _G.CastModifier or {}
MMC.mouseoverUnit = MMC.mouseoverUnit or nil;

local Extension = MMC.RegisterExtension("DiscordUnitFrames");
Extension.RegisterEvent("ADDON_LOADED", "OnLoad");

function Extension.OnEnterFrame()
    MMC.mouseoverUnit = this.unit;
end

function Extension.OnLeaveFrame()
    MMC.mouseoverUnit = nil;
end

function Extension.OnEnterElement()
    MMC.mouseoverUnit = this:GetParent().unit;
end

function Extension.OnLeaveElement()
    MMC.mouseoverUnit = nil;
end

function Extension.OnLoad()
    if arg1 ~= "DiscordUnitFrames" then
        return;
    end
    
    MMC.ClearHooks();
    Extension.Hook("DUF_UnitFrame_OnEnter", "OnEnterFrame");
    Extension.Hook("DUF_UnitFrame_OnLeave", "OnLeaveFrame");
    
    Extension.Hook("DUF_Element_OnEnter", "OnEnterElement");
    Extension.Hook("DUF_Element_OnLeave", "OnLeaveElement");
end

_G["CastModifier"] = MMC;