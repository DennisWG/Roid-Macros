--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License

	Last Modified:
        10.16.2016 (DWG): Added comments
		10.16.2016 (DWG): Added license information
		2015 (DWG): Initial release
]]

-- Parses the given message and looks for any conditionals
-- msg: The message to parse
-- returns: The remaining spell name, the modifier if set, the unit id if set and help if set
-- remarks: if help == 1 then [help], if help == 0 then [harm], if help == nil then not set
function MMC_parseMsg(msg)
	-- if string is
	local modifier, target;
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
	
	local last = string.gfind(modifier, "%a+");
	local _mod;
	
	for w in string.gfind(modifier, "%a+") do
		if last == "mod" then
			_mod = w;
		elseif last == "target" then
			target = w;
		end
		if w == "help" then
			help = 1;
		elseif w == "harm" then
			help = 0;
		end
		last = w;
	end
	
	return msg, _mod, target, help;
end

-- Validates that the given modifier is pressed
-- modifier: The modifier to validate
-- returns: True if the given modifier is valid. False if it is not.
function MMC_CheckIfModifierIsPressed(modifier)
	if modifier == "alt" and IsAltKeyDown() then
		return true;
	elseif modifier == "ctrl" and IsControlKeyDown() then
		return true;
	elseif modifier == "shift" and IsShiftKeyDown() then
		return true;
	end
	
	return false;
end

-- Validates that the given target is either friend (if [help]) or foe (if [harm])
-- target: The unit id to check
-- help: Optional. If set to 1 then the target must be friendly. If set to 0 it must be an enemy.
-- remarks: Will always return true if help is not given
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


--/cast [mod:ctrl, target=player] Detect Greater Invisibility
--/cast [help target=mouseover] Detect Greater Invisibility
--/cast [target=player] Holy Light
function MMC_DoCast(editBox, fun, msg)
	local modifier;
	msg, modifier, target, help = MMC_parseMsg(msg);
    
	if not modifier and not target and not help then
		if not msg then
			return;
		else
			fun(msg);
			editBox:AddHistoryLine(text);
			ChatEdit_OnEscapePressed(editBox);
			return;
		end
	end
	
	if modifier then
		if not MMC_CheckIfModifierIsPressed(modifier) then
			ChatEdit_OnEscapePressed(editBox);
			return;
		end
	end
	
	if not target then
		target = "target";
	end
	if not MMC_IsValidTarget(target, help) then
		ChatEdit_OnEscapePressed(editBox);
		return;
	end
	
	if target == "mouseover" then
		if help == 0 then
			TargetUnit(target);
			CastSpellByName(msg);
			ChatEdit_OnEscapePressed(editBox);
			return;
		end
		CM:Cast(msg);
		ChatEdit_OnEscapePressed(editBox);
		return;
	end
	
	CastSpellByName(msg);
	SpellTargetUnit(target);
	ChatEdit_OnEscapePressed(editBox);
end

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