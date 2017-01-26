--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local MMC = _G.CastModifier or {}
MMC.mouseoverUnit = MMC.mouseoverUnit or nil;

local Extension = MMC.RegisterExtension("CT_UnitFrames");
Extension.RegisterEvent("ADDON_LOADED", "OnLoad");

function Extension.SetHook(widget)
    local hookedOnEnter = widget:GetScript("OnEnter");
    local hookedOnLeave = widget:GetScript("OnLeave");
    
    widget:SetScript("OnEnter", function()
        hookedOnEnter();
        MMC.mouseoverUnit = "targettarget";
    end);
    
    widget:SetScript("OnLeave", function()
        hookedOnLeave();
        MMC.mouseoverUnit = nil;
    end);
end

function Extension.OnLoad()
    if arg1 ~= "CT_UnitFrames" or not CT_AssistFrame then
        return;
    end
    MMC.Print("CT_UnitFrames module loaded.");
    
    Extension.SetHook(CT_AssistFrame);
    Extension.SetHook(CT_AssistFrameHealthBar);
    Extension.SetHook(CT_AssistFrameManaBar);
    Extension.SetHook(CT_AssistFrame_Drag);
end

_G["CastModifier"] = MMC;