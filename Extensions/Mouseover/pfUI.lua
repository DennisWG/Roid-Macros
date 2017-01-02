--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local MMC = _G.CastModifier or {}

MMC.mouseoverUnit = MMC.mouseoverUnit or nil;

local Extension = MMC.RegisterExtension("pfUI");
Extension.RegisterEvent("PLAYER_ENTERING_WORLD", "PLAYER_ENTERING_WORLD");

function Extension.OnLoad()
end

function Extension.RegisterPlayerScripts()
    local onEnterFunc = pfUI.uf.player:GetScript("OnEnter");
    local onLeaveFunc = pfUI.uf.player:GetScript("OnLeave");
    
    pfUI.uf.player:SetScript("OnEnter", function()
        MMC.mouseoverUnit = "player";
        if onEnterFunc then
            onEnterFunc();
        end
    end);
    
    pfUI.uf.player:SetScript("OnLeave", function()
        MMC.mouseoverUnit = nil;
        if onLeaveFunc then
            onLeaveFunc();
        end
    end);
end

function Extension.RegisterTargetScripts()
    local onEnterFunc = pfUI.uf.target:GetScript("OnEnter");
    local onLeaveFunc = pfUI.uf.target:GetScript("OnLeave");
    
    pfUI.uf.target:SetScript("OnEnter", function()
        MMC.mouseoverUnit = "target";
        if onEnterFunc then
            onEnterFunc();
        end
    end);
    
    pfUI.uf.target:SetScript("OnLeave", function()
        MMC.mouseoverUnit = nil;
        if onLeaveFunc then
            onLeaveFunc();
        end
    end);
end

function Extension.RegisterTargetTargetScripts()
    local onEnterFunc = pfUI.uf.targettarget:GetScript("OnEnter");
    local onLeaveFunc = pfUI.uf.targettarget:GetScript("OnLeave");
    
    pfUI.uf.targettarget:SetScript("OnEnter", function()
        MMC.mouseoverUnit = "targettarget";
        if onEnterFunc then
            onEnterFunc();
        end
    end);
    
    pfUI.uf.targettarget:SetScript("OnLeave", function()
        MMC.mouseoverUnit = nil;
        if onLeaveFunc then
            onLeaveFunc();
        end
    end);
end

function Extension.PLAYER_ENTERING_WORLD()
    if not pfUI then
        return;
    end
    Extension.RegisterPlayerScripts();
    Extension.RegisterTargetScripts();
    Extension.RegisterTargetTargetScripts();
end
