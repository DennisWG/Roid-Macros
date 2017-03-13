local _G = _G or getfenv(0)
local MMC = _G.CastModifier or {}

MMC.Hooks = MMC.Hooks or {};
MMC.mouseoverUnit = MMC.mouseoverUnit or nil;

local Extension = MMC.RegisterExtension("ag_UnitFrames");
Extension.RegisterEvent("ADDON_LOADED", "OnLoad");

function Extension.OnEnter(unit)
    MMC.mouseoverUnit = unit;
end

function Extension.OnLeave()
    MMC.mouseoverUnit = nil;
end

-- Because AddOns are loaded in alphabetical order, this callback will never see the aUF loaded message, had to do a workaround...
function Extension.OnLoad()
    if not aUF then
        return
    end
    MMC.Hooks.ag_UnitFrames = { OnEnter = aUF.classes.aUFunit.prototype.OnEnter, OnLeave = aUF.classes.aUFunit.prototype.OnLeave}
    aUF.classes.aUFunit.prototype.OnEnter = MMC.aUFOnEnter
    aUF.classes.aUFunit.prototype.OnLeave = MMC.aUFOnLeave
    Extension.UnregisterEvent("ADDON_LOADED", "Onload")
end

-- Taken from ag_UnitClass.lua
function MMC:aUFOnEnter()
    Extension.OnEnter(self.unit)
    self.frame.unit = self.unit
    self:UpdateHighlight(true)
    UnitFrame_OnEnter()
end

function MMC:aUFOnLeave()
    Extension.OnLeave()
    self:UpdateHighlight()
    UnitFrame_OnLeave()
end


_G["CastModifier"] = MMC;
