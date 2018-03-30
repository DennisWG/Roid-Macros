--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local Roids = _G.Roids or {}
Roids.mouseoverUnit = Roids.mouseoverUnit or nil;

local Extension = Roids.RegisterExtension("NotGrid");
Extension.RegisterEvent("ADDON_LOADED", "OnLoad");

function Extension.OnEnter()
    Roids.mouseoverUnit = this.unit;
end

function Extension.OnLeave()
    Roids.mouseoverUnit = nil;
end

function Extension.ConfigUnitFrame(_, frame)
    local pattern = "%d+";
    local name = frame:GetName();
    
    enter = frame:GetScript("OnEnter");
    leave = frame:GetScript("OnLeave");
    
    frame:SetScript("OnEnter", function()
        enter();
        Extension.OnEnter();
    end);
    
    frame:SetScript("OnLeave", function()
        leave();
        Extension.OnLeave();
    end);
end

function Extension.OnLoad()
    if arg1 ~= "NotGrid" then
        return;
    end
    
    Extension.HookMethod(_G["NotGrid"], "ConfigUnitFrame", "ConfigUnitFrame");
end

_G["Roids"] = Roids;