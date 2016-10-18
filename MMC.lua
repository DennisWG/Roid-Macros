--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License

	Last Modified:
        10.18.2016 (DWG): Restructured code and added Conditionals for [no]combat and [no]stealth
        10.17.2016 (DWG): Added Shapeshift Conditionals
        10.16.2016 (DWG): Implemented conditional casts
        10.16.2016 (DWG): Added comments
        10.16.2016 (DWG): Added license information
        2015 (DWG): Initial release
]]

-- Validates that the given target is either friend (if [help]) or foe (if [harm])
-- target: The unit id to check
-- help: Optional. If set to 1 then the target must be friendly. If set to 0 it must be an enemy.
-- remarks: Will always return true if help is not given
-- returns: Whether or not the given target can either be attacked or supported, depending on help
function MMC_CheckHelp(target, help)
	if help then
		if help == 1 then
			if not UnitIsFriend(target, "player") then
				return false;
			end								
		else
			if UnitIsFriend(target, "player") then
				return false;
			end		
		end
	end
	return true;
end

-- Ensures the validity of the given target
-- target: The unit id to check
-- help: Optional. If set to 1 then the target must be friendly. If set to 0 it must be an enemy
-- returns: Whether or not the target is a viable target
function MMC_IsValidTarget(target, help)
	if target ~= "mouseover" then
		if not MMC_CheckHelp(target, help) or not UnitExists(target) then
			return false;
		end
		return true;
	end
	
	if (not CM or not CM.currentUnit) and not UnitName("mouseover") then
		return false;
	end
	
	return MMC_CheckHelp(target, help);
end

-- Returns the current shapeshift / stance index
-- returns: The index of the current shapeshift form / stance. 0 if in no shapeshift form / stance
function MMC_GetCurrentShapeshiftIndex()
    for i=1, GetNumShapeshiftForms() do
        _, _, active = GetShapeshiftFormInfo(i);
        if active then
            return i; 
        end
    end
    
    return 0;
end

-- Checks whether or not the given textureName is present in the current player's buff bar
-- textureName: The full name (including path) of the texture
-- returns: True if the texture can be found, false otherwhise
function MMC_HasBuff(textureName)
    for i = 1, 16 do
        if UnitBuff("player", i) == textureName then
            return true;
        end
    end
    
    return false;
end

-- A list of Conditionals and their functions to validate them
local MMC_Keywords = {
    stance = function(conditionals)
        local inStance = false;
        for k,v in pairs(MMC_splitString(conditionals.stance, "/")) do
            if MMC_GetCurrentShapeshiftIndex() == tonumber(v) then
                inStance = true;
                break;
            end
        end
        
        if not inStance then
            return false;
        end
        return true;
    end,
    
    mod = function(conditionals)    
        if conditionals.mod == "alt" and IsAltKeyDown() then
            return true;
        elseif conditionals.mod == "ctrl" and IsControlKeyDown() then
            return true;
        elseif conditionals.mod == "shift" and IsShiftKeyDown() then
            return true;
        end
        
        return false;
    end,
    
    target = function(conditionals)
        return MMC_IsValidTarget(conditionals.target, conditionals.help);
    end,
    
    combat = function(conditionals)
        return UnitAffectingCombat("player");
    end,
    
    nocombat = function(conditionals)
        return not UnitAffectingCombat("player");
    end,
    
    stealth = function(conditionals)
        return MMC_HasBuff("Interface\\Icons\\Ability_Ambush");
    end,
    
    nostealth = function(conditionals)
        return not MMC_HasBuff("Interface\\Icons\\Ability_Ambush");
    end,
};

-- Parses the given message and looks for any conditionals
-- msg: The message to parse
-- returns: A set of conditionals found inside the given string
function MMC_parseMsg(msg)
	local modifier;
	local modifierEnd = string.find(msg, "]");
	local help = nil;
	
    -- If we find conditionals trim down the message to everything except the conditionals
	if string.sub(msg, 1, 1) == "[" and modifierEnd then
		modifier = string.sub(msg, 2, modifierEnd - 1);
		msg = string.sub(msg, modifierEnd + 2);
    -- No conditionals found. Just return the message as is
	else
		return msg;
	end
	
    local target;
    local conditionals = {};
    
    local pattern = "(@*%w+:*%w*/*%w*)";
    for w in string.gfind(modifier, pattern) do
        local delimeter = string.find(w, ":");
        -- x:y
        if delimeter then
            local conditional = string.sub(w, 1, delimeter - 1);
            conditionals[conditional] = string.sub(w, delimeter + 1);
        -- @target
        elseif string.sub(w, 1, 1) == "@" then
            conditionals["target"] = string.sub(w,  2);
        -- Any other keyword like harm or help
        elseif MMC_Keywords[w] ~= nil then
            conditionals[w] = 1;
        end
    end
    
	return msg, conditionals;
end

-- A very primitive way of trying to verify that the given target is the same as the player's current target
-- target: The target to check
-- returns: True if the target and the player's target share some values
function MMC_VerifyIdentity(target)
    local plvl = UnitLevel("playertarget");
    local tlvl = UnitLevel(target);
    local pmana = UnitMana("playertarget");
    local tmana = UnitMana(target);
    local pmaxmana = UnitManaMax("playertarget");
    local tmaxmana = UnitManaMax(target);
    
    return plvl == tlvl and pmana == tmana and pmaxmana == tmaxmana;
end

-- Attempts to cast a single spell
-- editBox: Blizzard stuff
-- fun: Blizzard stuff
-- msg: The conditions followed by the spell name
-- returns: True if the spell has been casted. False if it has not.
function MMC_DoCastOne(editBox, fun, msg)
    local msg, conditionals = MMC_parseMsg(msg);
    
    -- No conditionals. Just exit.
    if not conditionals then
        if not msg or not fun then
            return false;
        else
            fun(msg);
            
            if editBox then
                editBox:AddHistoryLine(text);
            end
            return false;
        end
    end
    
    if not conditionals.target then
        conditionals.target = "target";
    end
    
    local help = nil;
    if conditionals.help then
        help = 1;
    elseif conditionals.harm then
        help = 0;
    end
    
    for k, v in pairs(conditionals) do
        if not MMC_Keywords[k] or not MMC_Keywords[k](conditionals) then
            return false;
        end
    end
        
    if target == "mouseover" then
        if help == 0 then
            TargetUnit(target);
            CastSpellByName(msg);
            return true;
        end
        CM:Cast(msg);
        return true;
    end
    
    local needRetarget = false;
    -- if our current target is not equal to the specified target...
    if not MMC_VerifyIdentity(conditionals.target) then
        needRetarget = true;
    end
    
    TargetUnit(conditionals.target);
    CastSpellByName(msg);
    
    -- ... then we have to re-target it after casting the spell!
    if needRetarget then
        TargetLastTarget();
    end
    
    return true;
end

-- Attempts to cast a single spell from the given set of conditional spells
-- editBox: Blizzard stuff
-- fun: Blizzard stuff
-- msg: The player's macro text
function MMC_DoCast(editBox, fun, msg)
    for k, v in pairs(MMC_splitString(msg, ";%s*")) do
        if MMC_DoCastOne(editBox, fun, v) then
            break;
        end
    end
    
    if editBox then
        ChatEdit_OnEscapePressed(editBox);
    end
end

-- Dummy Frame to hook ADDON_LOADED event in order to preserve compatiblity with other AddOns like SuperMacro
local MMC_Frame = CreateFrame("FRAME", "MMCDummyFrame");
MMC_Frame:SetScript("OnEvent", function()
    if event ~= "ADDON_LOADED" or arg1 ~= "SuperMacro" then
        return;
    end
    
    -- Hook SuperMacro's RunLine to stay compatible
    local RunLineOrig = RunLine;
    RunLine = function(...)
        for k = 1, arg.n do
            local text = arg[k];
            -- if we find '/cast [' take over execution
            local begin, _end = string.find(text, "^/cast%s*%[");
            if begin then
                local msg = string.sub(text, _end);
                ChatFrame1:AddMessage(msg);
                MMC_DoCast(nil, SlashCmdList["CAST"], msg);
                
            -- if not pass it along to SuperMacro
            else
                RunLineOrig(text);
            end
        end
    end
end);
MMC_Frame:RegisterEvent("ADDON_LOADED");

-- Mostly Blizzards stuff (ChatFrame.lua)
ChatEdit_ParseText = function(editBox, send)
	local text = editBox:GetText();
	if ( strlen(text) <= 0 ) then
		return;
	end

	if ( strsub(text, 1, 1) ~= "/" ) then
		return;
	end

	-- If the string is in the format "/cmd blah", command will be "cmd"
	local command = gsub(text, "/([^%s]+)%s(.*)", "/%1", 1);
	local msg = "";


	if ( command ~= text ) then
		msg = strsub(text, strlen(command) + 2);
	end

	command = gsub(command, "%s+", "");
	command = strupper(command);
	local channel = gsub(command, "/([0-9]+)", "%1");

	if( strlen(channel) > 0 and channel >= "0" and channel <= "9" ) then
		local channelNum, channelName = GetChannelName(channel);
		if ( channelNum > 0 ) then
			editBox.channelTarget = channelNum;
			command = strupper(SLASH_CHANNEL1);
			editBox.chatType = "CHANNEL";
			editBox:SetText(msg);
			ChatEdit_UpdateHeader(editBox);
			return;
		end
	else
		for index, value in ChatTypeInfo do
			local i = 1;
			local cmdString = TEXT(getglobal("SLASH_"..index..i));
			while ( cmdString ) do
				cmdString = strupper(cmdString);
				if ( cmdString == command ) then
					if ( index == "WHISPER" ) then
						ChatEdit_ExtractTellTarget(editBox, msg);
					elseif ( index == "REPLY" ) then
						local lastTell = ChatEdit_GetLastTellTarget(editBox);
						if ( strlen(lastTell) > 0 ) then
							editBox.chatType = "WHISPER";
							editBox.tellTarget = lastTell;
							editBox:SetText(msg);
							ChatEdit_UpdateHeader(editBox);
						else
							if ( send == 1 ) then
								ChatEdit_OnEscapePressed(editBox);
							end
							return;
						end
					elseif (index == "CHANNEL") then
						ChatEdit_ExtractChannel(editBox, msg);
					else
						editBox.chatType = index;
						editBox:SetText(msg);
						ChatEdit_UpdateHeader(editBox);
					end
					return;
				end
				i = i + 1;
				cmdString = TEXT(getglobal("SLASH_"..index..i));
			end
		end
	end

	if ( send == 0 ) then
		return;
	end

	for index, value in SlashCmdList do
		local i = 1;
		local cmdString = TEXT(getglobal("SLASH_"..index..i));
		while ( cmdString ) do
			cmdString = strupper(cmdString);
			if ( cmdString == command ) then
				if cmdString == "/CAST" then
					MMC_DoCast(editBox, value, msg);
					return;
				else
					value(msg);
					editBox:AddHistoryLine(text);
					ChatEdit_OnEscapePressed(editBox);
					return;
				end
			end
			i = i + 1;
			cmdString = TEXT(getglobal("SLASH_"..index..i));
		end
	end

	local i = 1;
	local j = 1;
	local cmdString = TEXT(getglobal("EMOTE"..i.."_CMD"..j));
	while ( cmdString ) do
		if ( strupper(cmdString) == command ) then
			local token = getglobal("EMOTE"..i.."_TOKEN");
			if ( token ) then
				DoEmote(token, msg);
			end
			editBox:AddHistoryLine(text);
			ChatEdit_OnEscapePressed(editBox);
			return;
		end
		j = j + 1;
		cmdString = TEXT(getglobal("EMOTE"..i.."_CMD"..j));
		if ( not cmdString ) then
			i = i + 1;
			j = 1;
			cmdString = TEXT(getglobal("EMOTE"..i.."_CMD"..j));
		end
	end


	-- Unrecognized chat command, show simple help text
	local info = ChatTypeInfo["SYSTEM"];
	editBox.chatFrame:AddMessage(TEXT(HELP_TEXT_SIMPLE), info.r, info.g, info.b, info.id);
	ChatEdit_OnEscapePressed(editBox);
end