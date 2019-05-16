local _G = _G or getfenv(0)
local Roids = _G.Roids or {}

local Extension = Roids.RegisterExtension("Compatibility_pfUI");
Extension.RegisterEvent("ADDON_LOADED", "OnLoad");
Extension.Debug = 1;

function Extension.RunMacro(name)
    Roids.ExecuteMacroByName(name);
end

function Extension.DLOG(msg)
    if Extension.Debug then
        DEFAULT_CHAT_FRAME:AddMessage("|cffcccc33[R]: |cffffff55" .. ( msg ))
    end
end

function Extension.FocusNameHook()
    local hook = Extension.internal.memberHooks[Roids]["GetFocusName"]
    local target = hook.origininal()
    
    if pfUI and pfUI.uf and pfUI.uf.focus and pfUI.uf.focus.unitname then
        target = pfUI.uf.focus.unitname
    end
    
    --Extension.DLOG(target)
    
    return target
end

function Extension.OnLoad()
    Extension.DLOG("Extension pfUI Loaded.")
    Extension.HookMethod(Roids, "GetFocusName", "FocusNameHook", true)
    Extension.UnregisterEvent("ADDON_LOADED", "Onload");
end


_G["Roids"] = Roids;
