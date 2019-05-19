local _G = _G or getfenv(0)
local Roids = _G.Roids or {}

local Extension = Roids.RegisterExtension("Compatibility_pfUI");
Extension.RegisterEvent("ADDON_LOADED", "OnLoad");

function Extension.RunMacro(name)
    Roids.ExecuteMacroByName(name);
end

function Extension.FocusNameHook()
    local hook = Extension.internal.memberHooks[Roids]["GetFocusName"]
    local target = hook.origininal()
    
    if pfUI and pfUI.uf and pfUI.uf.focus and pfUI.uf.focus.unitname and pfUI.uf.focus:IsShown() then
        target = pfUI.uf.focus.unitname
    end
    
    return target
end

function Extension.OnLoad()
    Extension.HookMethod(Roids, "GetFocusName", "FocusNameHook", true)
    Extension.UnregisterEvent("ADDON_LOADED", "Onload");
end


_G["Roids"] = Roids;
