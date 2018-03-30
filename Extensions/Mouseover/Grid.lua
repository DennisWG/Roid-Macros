--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local Roids = _G.Roids or {}

Roids.Hooks = Roids.Hooks or {};
Roids.mouseoverUnit = Roids.mouseoverUnit or nil;

local Extension = Roids.RegisterExtension("Grid");
Extension.RegisterEvent("ADDON_LOADED", "OnLoad");

function Extension.OnEnter(unit)
    Roids.mouseoverUnit = unit;
end

function Extension.OnLeave()
    Roids.mouseoverUnit = nil;
end

function Extension.OnLoad()
    if arg1 ~= "Grid" then
        return;
    end
    
    Roids.Hooks.Grid = { CreateFrames = GridFrame.frameClass.prototype.CreateFrames};
    GridFrame.frameClass.prototype.CreateFrames = Roids.GrdCreateFrames;
end

-- Taken from GridFrame.lua and added OnEnter and OnLeave scripts
function Roids:GrdCreateFrames()
	-- create frame
	--self.frame = CreateFrame("Button", nil, UIParent)
	local f = self.frame
    
	f:SetScript("OnEnter", function()
        Extension.OnEnter(self.unit);
    end);
	f:SetScript("OnLeave", function()
        Extension.OnLeave();
    end);

	-- f:Hide()
	f:EnableMouse(true)			
	f:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp", "Button4Up", "Button5Up")
	f:SetWidth(GridFrame:GetFrameSize())
	f:SetHeight(GridFrame:GetFrameSize())
	
	-- only use SetScript pre-TBC
	if Grid.isTBC then
		f:SetAttribute("type1", "target")
	else
		f:SetScript("OnClick", function () GridFrame_OnClick(f, arg1) end)
		f:SetScript("OnAttributeChanged", GridFrame_OnAttributeChanged)
	end
	
	-- create border
	f:SetBackdrop({
		bgFile = "Interface\\Addons\\Grid\\white16x16", tile = true, tileSize = 16,
		edgeFile = "Interface\\Addons\\Grid\\white16x16", edgeSize = 1,
		insets = {left = 1, right = 1, top = 1, bottom = 1},
	})
	f:SetBackdropBorderColor(0,0,0,0)
	f:SetBackdropColor(0,0,0,1)
	
	-- create bar BG (which users will think is the real bar, as it is the one that has a shiny color)
	-- this is necessary as there's no other way to implement status bars that grow in the other direction than normal
	f.BarBG = f:CreateTexture()
	f.BarBG:SetTexture("Interface\\Addons\\Grid\\gradient32x32")
	f.BarBG:SetPoint("CENTER", f, "CENTER")
	f.BarBG:SetWidth(GridFrame:GetFrameSize()-4)
	f.BarBG:SetHeight(GridFrame:GetFrameSize()-4)

	-- create bar
	f.Bar = CreateFrame("StatusBar", nil, f)
	f.Bar:SetStatusBarTexture("Interface\\Addons\\Grid\\gradient32x32")
	f.Bar:SetOrientation("VERTICAL")
	f.Bar:SetMinMaxValues(0,100)
	f.Bar:SetValue(100)
	f.Bar:SetStatusBarColor(0,0,0,0.8)
	f.Bar:SetPoint("CENTER", f, "CENTER")
	f.Bar:SetFrameLevel(4)
	f.Bar:SetWidth(GridFrame:GetFrameSize()-4)
	f.Bar:SetHeight(GridFrame:GetFrameSize()-4)
	
	-- create center text
	f.Text = f.Bar:CreateFontString(nil, "ARTWORK")
	f.Text:SetFontObject(GameFontHighlightSmall)
	f.Text:SetFont(STANDARD_TEXT_FONT,8)
	f.Text:SetJustifyH("CENTER")
	f.Text:SetJustifyV("CENTER")
	f.Text:SetPoint("CENTER", f, "CENTER")
	
	-- create icon
	f.Icon = f.Bar:CreateTexture("Icon", "OVERLAY")
	f.Icon:SetWidth(16)
	f.Icon:SetHeight(16)
	f.Icon:SetPoint("CENTER", f, "CENTER")
	f.Icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
	f.Icon:SetTexture(1,1,1,0) --"Interface\\Icons\\INV_Misc_Orb_02"
	
	-- set texture
	f:SetNormalTexture(1,1,1,0)
	f:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	
	self.frame = f
	
	-- set up click casting
	ClickCastFrames = ClickCastFrames or {}
	ClickCastFrames[self.frame] = true
end

_G["Roids"] = Roids;