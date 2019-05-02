local _G = _G or getfenv(0)
local Roids = _G.Roids or {}

local Extension = Roids.RegisterExtension("Compatibility_SuperMacro");
Extension.RegisterEvent("ADDON_LOADED", "OnLoad");

function Extension.RunMacro(name)
    Roids.ExecuteMacroByName(name)
end

function Extension.OnLoad()
    if not SuperMacroFrame then
        return;
    end

    Extension.Hook("RunMacro", "RunMacro", true);
    Extension.UnregisterEvent("ADDON_LOADED", "Onload");
end


_G["Roids"] = Roids;