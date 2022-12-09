--[[
	Author: Fondlez (http://github.com/fondlez)
  
  This extension adds support for mouseover macros in Roid-Macros for the
  the default Blizzard target-of-target frame.
]]
local _G = _G or getfenv(0)
local Roids = _G.Roids or {}
Roids.mouseoverUnit = Roids.mouseoverUnit or nil;

local Extension = Roids.RegisterExtension("Blizzard");

function Extension.RegisterMouseoverForFrame(frame, unit)
    if not frame then return end
    
    local onenter = frame:GetScript("OnEnter");
    local onleave = frame:GetScript("OnLeave");
    
    frame:SetScript("OnEnter", function()
        Roids.mouseoverUnit = unit;
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
    Extension.RegisterMouseoverForFrame(TargetofTargetHealthBar, 
      "targettarget");
    Extension.RegisterMouseoverForFrame(TargetofTargetManaBar, "targettarget");
    Extension.RegisterMouseoverForFrame(TargetofTargetFrame, "targettarget");
end
