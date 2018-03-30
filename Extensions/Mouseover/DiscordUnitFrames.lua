--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local Roids = _G.Roids or {}
Roids.mouseoverUnit = Roids.mouseoverUnit or nil;

local Extension = Roids.RegisterExtension("DiscordUnitFrames");
Extension.RegisterEvent("ADDON_LOADED", "OnLoad");

function Extension.OnEnterFrame()
    Roids.mouseoverUnit = this.unit;
end

function Extension.OnLeaveFrame()
    Roids.mouseoverUnit = nil;
end

function Extension.OnEnterElement()
    Roids.mouseoverUnit = this:GetParent().unit;
end

function Extension.OnLeaveElement()
    Roids.mouseoverUnit = nil;
end

function Extension.OnLoad()
    if arg1 ~= "DiscordUnitFrames" then
        return;
    end
    
    Roids.ClearHooks();
    Extension.Hook("DUF_UnitFrame_OnEnter", "OnEnterFrame");
    Extension.Hook("DUF_UnitFrame_OnLeave", "OnLeaveFrame");
    
    Extension.Hook("DUF_Element_OnEnter", "OnEnterElement");
    Extension.Hook("DUF_Element_OnLeave", "OnLeaveElement");
end

_G["Roids"] = Roids;