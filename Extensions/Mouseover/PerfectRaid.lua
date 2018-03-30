--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local Roids = _G.Roids or {}

Roids.Hooks = Roids.Hooks or {};
Roids.mouseoverUnit = Roids.mouseoverUnit or nil;

local Extension = Roids.RegisterExtension("PerfectRaid");
Extension.RegisterEvent("ADDON_LOADED", "OnLoad");

function Extension.OnEnter(unit)
    Roids.mouseoverUnit = unit;
end

function Extension.OnLeave()
    Roids.mouseoverUnit = nil;
end

function Extension.OnLoad()
    if arg1 ~= "PerfectRaid" then
        return;
    end
    
    Roids.Hooks.PerfectRaid = { CreateFrame = PerfectRaid.CreateFrame };
    PerfectRaid.CreateFrame = Roids.PerfectRaidCreateFrame;
end

function Roids.PerfectRaidCreateFrame(self, num)
    -- We need to allocate up to num frames
    
    if self.poolsize >= num then return end

--[[
    local mem,thr = gcinfo()
    self:Msg("Memory Usage Before: %s [%s].", mem, thr)
--]]
    local side = self.opt.Align
    
    local justify,point,relative,offset
    
    if side == "left" then
        justify = "RIGHT"
        point = "LEFT"
        relative = "RIGHT"
        offset = 5
    elseif side == "right" then
        justify = "LEFT"
        point = "RIGHT"
        relative = "LEFT"
        offset = -5
    end
    
    for i=(self.poolsize + 1),num do
        local frame = CreateFrame("Button", nil, PerfectRaidFrame)
        frame:EnableMouse(true)
        frame.unit = "raid"..i
        frame.id = i
        frame:SetWidth(225)
        frame:SetHeight(13)
        frame:SetMovable(true)
        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", function() self["master"]:StartMoving() end)
        frame:SetScript("OnDragStop", function() self["master"]:StopMovingOrSizing() self:SavePosition() end)
        frame:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp", "Button4Up", "Button5Up")
        frame:SetScript("OnClick", self.OnClick)
        frame:SetScript("OnEnter", function()
            Extension.OnEnter(this.unit);
        end);
        frame:SetScript("OnLeave", function()
            Extension.OnLeave();
        end);
        frame:SetParent(self.master)

        local font = frame:CreateFontString(nil, "ARTWORK")
        font:SetFontObject(GameFontHighlightSmall)
        font:SetText("WW")
        font:SetJustifyH("CENTER")
        font:SetWidth(font:GetStringWidth())
        font:SetHeight(14)
        font:Show()
        font:ClearAllPoints()
        font:SetPoint(point, frame, relative,0, 0)
        -- Add this font string to the frame
        frame.Prefix = font
        
        font = frame:CreateFontString(nil, "ARTWORK")
        font:SetFontObject(GameFontHighlightSmall)
        font:SetText()
        font:SetJustifyH(justify)
        font:SetWidth(55)
        font:SetHeight(12)
        font:Show()
        font:ClearAllPoints()
        font:SetPoint(point, frame.Prefix, relative, offset, 0)
        -- Add this font string to the frame
        frame.Name = font
        
        local bar = CreateFrame("StatusBar", nil, frame)
        bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
        bar:SetMinMaxValues(0,100)
        bar:ClearAllPoints()
        bar:SetPoint(point, frame.Name, relative, offset, 0)
        bar:SetWidth(60)
        bar:SetHeight(7)
        bar:Show()
        -- Add this status bar to the frame
        frame.Bar = bar
        
        font = frame:CreateFontString(nil, "ARTWORK")
        font:SetFontObject(GameFontHighlightSmall)
        font:SetText("")
        font:SetJustifyH(justify)
        font:SetWidth(font:GetStringWidth())
        font:SetHeight(12)
        font:Show()
        font:ClearAllPoints()
        font:SetPoint(point, frame.Bar, relative, offset, 0)
        -- Add this font string to the frame
        frame.Status = font
        
        -- Lets set the frame in the indexed array
        self.frames[i] = frame
        self.frames["raid"..i] = frame
        self.poolsize = i
    end
    
    mem2,thr2 = gcinfo()
--[[
    self:Msg("Memory Usage After: %s [%s].", mem2, thr2)
    self:Msg("Frame creation change: %s [%s].", mem2 - mem, thr2 - thr)
--]]
end

_G["Roids"] = Roids;