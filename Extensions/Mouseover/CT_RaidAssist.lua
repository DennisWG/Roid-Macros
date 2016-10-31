--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local MMC = _G.CastModifier or {}
MMC.mouseoverUnit = MMC.mouseoverUnit or nil;

local Extension = MMC.RegisterExtension("CT_RaidAssist");
Extension.RegisterEvent("ADDON_LOADED", "OnLoad");

function Extension.OnEnter()
	local tempOptions = CT_RAMenu_Options["temp"];
	if ( SpellIsTargeting() ) then
		SetCursor("CAST_CURSOR");
	end
	local parent = this.frameParent;
	local id = parent.id;
	if ( strsub(parent.name, 1, 12) == "CT_RAMTGroup" ) then
		local name;
		if ( CT_RA_MainTanks[id] ) then
			name = CT_RA_MainTanks[id];
		end
		for i = 1, GetNumRaidMembers(), 1 do
			local memberName = GetRaidRosterInfo(i);
			if ( name == memberName ) then
				id = i;
				break;
			end
		end
	elseif ( strsub(parent.name, 1, 12) == "CT_RAPTGroup" ) then
		local name;
		if ( CT_RA_PTargets[id] ) then
			name = CT_RA_PTargets[id];
		end
		for i = 1, GetNumRaidMembers(), 1 do
			local memberName = GetRaidRosterInfo(i);
			if ( name == memberName ) then
				id = i;
				break;
			end
		end
	end
	MMC.mouseoverUnit = "raid"..id;
end

function Extension.OnLeave()
    MMC.mouseoverUnit = nil;
end

function Extension.OnLoad()
    if arg1 ~= "CT_RaidAssist" then
        return;
    end
    
    Extension.Hook("CT_RA_MemberFrame_OnEnter", "OnEnter");
    Extension.HookMethod(_G["GameTooltip"], "Hide", "OnLeave");
    Extension.HookMethod(_G["GameTooltip"], "FadeOut", "OnLeave");

end

_G["CastModifier"] = MMC;