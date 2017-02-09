--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local MMC = _G.CastModifier or {}
MMC.mouseoverUnit = MMC.mouseoverUnit or nil;

local Extension = MMC.RegisterExtension("NotGrid");
Extension.RegisterEvent("ADDON_LOADED", "OnLoad");

function Extension.OnEnter()
    MMC.mouseoverUnit = this.unit;
end

function Extension.OnLeave()
    MMC.mouseoverUnit = nil;
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

_G["CastModifier"] = MMC;