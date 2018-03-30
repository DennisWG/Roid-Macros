--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local Roids = _G.Roids or {}
Roids.mouseoverUnit = Roids.mouseoverUnit or nil;

local Extension = Roids.RegisterExtension("FocusFrame");

function Extension.RegisterMouseoverForFrame(frame)
    local onenter = frame:GetScript("OnEnter");
    local onleave = frame:GetScript("OnLeave");
    
    frame:SetScript("OnEnter", function()
        Roids.mouseoverUnit = "focus";
        if onenter then
            onenter();
        end
    end);
    
    frame:SetScript("OnLeave", function()
        Roids.mouseoverUnit = nil;
        if onleave then
            onleave();
        end
    end);
end

function Extension.OnLoad()
    if not FocusFrameHealthBar
      or not FocusFrameManaBar
      or not FocusFrameTextureFrame
      or not FocusFrame then
      return;
    end
    
    Extension.RegisterMouseoverForFrame(FocusFrameHealthBar);
    Extension.RegisterMouseoverForFrame(FocusFrameManaBar);
    Extension.RegisterMouseoverForFrame(FocusFrameTextureFrame);
    Extension.RegisterMouseoverForFrame(FocusFrame);
end