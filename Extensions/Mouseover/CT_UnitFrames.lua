--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local Roids = _G.Roids or {}
Roids.mouseoverUnit = Roids.mouseoverUnit or nil;

local Extension = Roids.RegisterExtension("CT_UnitFrames");
Extension.RegisterEvent("ADDON_LOADED", "OnLoad");

function Extension.SetHook(widget)
    local hookedOnEnter = widget:GetScript("OnEnter");
    local hookedOnLeave = widget:GetScript("OnLeave");
    
    widget:SetScript("OnEnter", function()
        hookedOnEnter();
        Roids.mouseoverUnit = "targettarget";
    end);
    
    widget:SetScript("OnLeave", function()
        hookedOnLeave();
        Roids.mouseoverUnit = nil;
    end);
end

function Extension.OnLoad()
    if arg1 ~= "CT_UnitFrames" or not CT_AssistFrame then
        return;
    end
    Roids.Print("CT_UnitFrames module loaded.");
    
    Extension.SetHook(CT_AssistFrame);
    Extension.SetHook(CT_AssistFrameHealthBar);
    Extension.SetHook(CT_AssistFrameManaBar);
    Extension.SetHook(CT_AssistFrame_Drag);
end

_G["Roids"] = Roids;