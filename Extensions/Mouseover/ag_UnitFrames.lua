local _G = _G or getfenv(0)
local Roids = _G.Roids or {}

Roids.Hooks = Roids.Hooks or {};
Roids.mouseoverUnit = Roids.mouseoverUnit or nil;

local Extension = Roids.RegisterExtension("ag_UnitFrames");
Extension.RegisterEvent("ADDON_LOADED", "OnLoad");

function Extension.OnEnter(unit)
    Roids.mouseoverUnit = unit;
end

function Extension.OnLeave()
    Roids.mouseoverUnit = nil;
end

-- Because AddOns are loaded in alphabetical order, this callback will never see the aUF loaded message, had to do a workaround...
function Extension.OnLoad()
    if not aUF then
        return
    end
    Roids.Hooks.ag_UnitFrames = { OnEnter = aUF.classes.aUFunit.prototype.OnEnter, OnLeave = aUF.classes.aUFunit.prototype.OnLeave}
    aUF.classes.aUFunit.prototype.OnEnter = Roids.aUFOnEnter
    aUF.classes.aUFunit.prototype.OnLeave = Roids.aUFOnLeave
    Extension.UnregisterEvent("ADDON_LOADED", "Onload")
end

-- Taken from ag_UnitClass.lua
function Roids:aUFOnEnter()
    Extension.OnEnter(self.unit)
    self.frame.unit = self.unit
    self:UpdateHighlight(true)
    UnitFrame_OnEnter()
end

function Roids:aUFOnLeave()
    Extension.OnLeave()
    self:UpdateHighlight()
    UnitFrame_OnLeave()
end


_G["Roids"] = Roids;
