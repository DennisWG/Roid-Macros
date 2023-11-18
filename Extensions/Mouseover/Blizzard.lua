--[[
	Author: Fondlez
  
  This extension adds improved support for mouseover macros in Roid-Macros 
  for the default Blizzard frames.
]]
local _G = _G or getfenv(0)
local Roids = _G.Roids or {}
Roids.mouseoverUnit = Roids.mouseoverUnit or nil

local Extension = Roids.RegisterExtension("Blizzard")

function Extension.RegisterMouseoverForFrame(frame, unit)
    if not frame then return end
    
    local onenter = frame:GetScript("OnEnter")
    local onleave = frame:GetScript("OnLeave")
    
    frame:SetScript("OnEnter", function()
        Roids.mouseoverUnit = unit
        if onenter then
            onenter()
        end
    end)
    
    frame:SetScript("OnLeave", function()
        Roids.mouseoverUnit = nil
        if onleave then
            onleave()
        end
    end)
end

do
    local frames = {
        ["PlayerFrame"] = "player",
        ["PetFrame"] = "pet",
        ["TargetFrame"] = "target",
        ["PartyMemberFrame1"] = "party1",
        ["PartyMemberFrame2"] = "party2",
        ["PartyMemberFrame3"] = "party3",
        ["PartyMemberFrame4"] = "party4",
        ["PartyMemberFrame1PetFrame"] = "party1",
        ["PartyMemberFrame2PetFrame"] = "party2",
        ["PartyMemberFrame3PetFrame"] = "party3",
        ["PartyMemberFrame4PetFrame"] = "party4",
    }
    
    local bars = { 
        "HealthBar", 
        "ManaBar",
    }
    
    local allFrames = {}
    for name, unit in pairs(frames) do
         allFrames[name] = unit
        for i, bar in ipairs(bars) do
            allFrames[name .. bar] = unit
        end
    end
    
    -- Inconsisent naming for TargetofTarget required
    allFrames["TargetofTargetFrame"] = "targettarget"
    allFrames["TargetofTargetHealthBar"] = "targettarget"
    allFrames["TargetofTargetManaBar"] = "targettarget"

    function Extension.OnLoad()
        local frame
        for name, unit in pairs(allFrames) do
          frame = _G[name]
          
          if frame then
              Extension.RegisterMouseoverForFrame(frame, unit)
          end
       end
    end
end
