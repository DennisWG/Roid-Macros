--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local Roids = _G.Roids or {}

Roids.mouseoverUnit = Roids.mouseoverUnit or nil;

local Extension = Roids.RegisterExtension("pfUI");
Extension.RegisterEvent("PLAYER_ENTERING_WORLD", "PLAYER_ENTERING_WORLD");

function Extension.OnLoad()
end

function Extension.RegisterPlayerScripts()
    local onEnterFunc = pfUI.uf.player:GetScript("OnEnter");
    local onLeaveFunc = pfUI.uf.player:GetScript("OnLeave");
    
    pfUI.uf.player:SetScript("OnEnter", function()
        Roids.mouseoverUnit = "player";
        if onEnterFunc then
            onEnterFunc();
        end
    end);
    
    pfUI.uf.player:SetScript("OnLeave", function()
        Roids.mouseoverUnit = nil;
        if onLeaveFunc then
            onLeaveFunc();
        end
    end);
end

function Extension.RegisterTargetScripts()
    local onEnterFunc = pfUI.uf.target:GetScript("OnEnter");
    local onLeaveFunc = pfUI.uf.target:GetScript("OnLeave");
    
    pfUI.uf.target:SetScript("OnEnter", function()
        Roids.mouseoverUnit = "target";
        if onEnterFunc then
            onEnterFunc();
        end
    end);
    
    pfUI.uf.target:SetScript("OnLeave", function()
        Roids.mouseoverUnit = nil;
        if onLeaveFunc then
            onLeaveFunc();
        end
    end);
end

function Extension.RegisterTargetTargetScripts()
    local onEnterFunc = pfUI.uf.targettarget:GetScript("OnEnter");
    local onLeaveFunc = pfUI.uf.targettarget:GetScript("OnLeave");
    
    pfUI.uf.targettarget:SetScript("OnEnter", function()
        Roids.mouseoverUnit = "targettarget";
        if onEnterFunc then
            onEnterFunc();
        end
    end);
    
    pfUI.uf.targettarget:SetScript("OnLeave", function()
        Roids.mouseoverUnit = nil;
        if onLeaveFunc then
            onLeaveFunc();
        end
    end);
end

function Extension.PLAYER_ENTERING_WORLD()
    if not pfUI or not pfUI.uf then
        return;
    end
    Extension.RegisterPlayerScripts();
    Extension.RegisterTargetScripts();
    Extension.RegisterTargetTargetScripts();
end
