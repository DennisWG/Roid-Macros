--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local MMC = _G.CastModifier or {}

-- A list of all registered extensions
MMC.Extensions = MMC.Extensions or {};

-- Calls the "OnLoad" function of every extension
function MMC.InitializeExtensions()
    for k, v in pairs(MMC.Extensions) do
        local func = v["OnLoad"];
        if not func then
            MMC.Print("MMC.InitializeExtensions - Couldn't find 'OnLoad' function for extension "..k);
        else
            func();
        end 
    end
end

-- Removes the given hook
-- hook: The hook to remove
function MMC.RemoveHook(hook)
    _G[hook.name] = hook.origininal;
end

-- Removes the given hook from the given object
-- object: The object to remove the hook from
-- hook: The hook to remove
function MMC.RemoveMethodHook(object, hook)
    object[hook.name] = hook.origininal;
end

-- Clears all previously declared hooks
function MMC.ClearHooks()
    for k, v in pairs(MMC.Extensions) do
        for k2, v2 in pairs(v.internal.memberHooks) do
            for k3, v3 in pairs(v2) do
                MMC.RemoveMethodHook(k2, v3);
            end
        end
        
        for k2, v2 in pairs(v.internal.hooks) do
            MMC.RemoveHook(v2);
        end
    end
end

-- Creates a new extension with the given name
-- name: the name of the extension
function MMC.RegisterExtension(name)    
    local extension = {
        internal =
        {
            frame = CreateFrame("FRAME"),
            eventHandlers = {},
            hooks = {},
            memberHooks = {},
        },
    };
    
    extension.RegisterEvent = function(eventName, callbackName)
        MMC.RegisterEvent(name, eventName, callbackName);
    end;
    
    extension.Hook = function(functionName, callbackName, dontCallOriginal)
        MMC.RegisterHook(name, functionName, callbackName, dontCallOriginal);
    end;
    
    extension.HookMethod = function(object, functionName, callbackName, dontCallOriginal)
        MMC.RegisterMethodHook(name, object, functionName, callbackName, dontCallOriginal);
    end;
    
    extension.internal.OnEvent = function()
        local callbackName = extension.internal.eventHandlers[event];
        if callbackName then
            extension[callbackName]();
        end
    end;
    
    extension.internal.OnHook = function(object, functionName, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
        local hook;
        
        if object then
            hook = extension.internal.memberHooks[object][functionName];
        else
            hook = extension.internal.hooks[functionName];
        end
        
        hook.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
        if not hook.dontCallOriginal then
            hook.origininal(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
        end
    end;
    
    extension.internal.frame:SetScript("OnEvent", extension.internal.OnEvent);
    
    MMC.Extensions[name] = extension;
    
    return extension;
end

-- Registers a callback function for a given event name
-- extensionName: The name of the extension trying to register the callback
-- eventName: The event's name we'd like to register a callback for
-- callbackName: The name of the callback that get's called when the event fires
function MMC.RegisterEvent(extensionName, eventName, callbackName)
    local extension = MMC.Extensions[extensionName];
    extension.internal.eventHandlers[eventName] = callbackName;
    extension.internal.frame:RegisterEvent(eventName);
end

-- Hooks the given function by it's name
-- extensionName: The name of the extension trying to register the callback
-- functionName: The name of the function that'll be hooked
-- callbackName: The name of the callback that get's called when the hooked function is called
-- dontCallOriginal: Set to true when the original function should not be called
function MMC.RegisterHook(extensionName, functionName, callbackName, dontCallOriginal)
    local orig = _G[functionName];
    local extension = MMC.Extensions[extensionName];
    
    if not extension then
        MMC.Print("MMC.RegisterHook - Invalid extension: "..extension);
        return;
    end
    
    if not extension[callbackName] then
        MMC.Print("MMC.RegisterHook - Couldn't find callback: "..callbackName);
        return;
    end
    
    
    extension.internal.hooks[functionName] = {
        origininal = orig,
        callback = extension[callbackName],
        name = functionName,
        dontCallOriginal = dontCallOriginal
    };
    
    _G[functionName] = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
        extension.internal.OnHook(nil, functionName, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
    end;
end

-- Hooks the given object's function
-- object: The object you want to hook
-- extensionName: The name of the extension trying to register the callback
-- functionName: The name of the function that'll be hooked
-- callbackName: The name of the callback that get's called when the hooked function is called
function MMC.RegisterMethodHook(extensionName, object, functionName, callbackName, dontCallOriginal)
    if not object then
        MMC.Print("MMC.RegisterMethodHook - The object could not be found!");
        return;
    end

    if type(object) ~= "table" then
        MMC.Print("MMC.RegisterMethodHook - The object needs to be a table!");
        return;
    end
    
    local orig = object[functionName];
    
    if not orig then
        MMC.Print("MMC.RegisterMethodHook - The object doesn't have a function named "..functionName);
        return;
    end
    
    local extension = MMC.Extensions[extensionName];
    
    if not extension then
        MMC.Print("MMC.RegisterMethodHook - Invalid extension: "..extension);
        return;
    end
    
    if not extension[callbackName] then
        MMC.Print("MMC.RegisterMethodHook - Couldn't find callback: "..callbackName);
        return;
    end
    
    if not extension.internal.memberHooks[object] then
        extension.internal.memberHooks[object] = {};
    end
    
    extension.internal.memberHooks[object][functionName] = {
        origininal = orig,
        callback = extension[callbackName],
        name = functionName,
        dontCallOriginal = dontCallOriginal
    };
    
    object[functionName] = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
        extension.internal.OnHook(object, functionName, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
    end;
end

_G["CastModifier"] = MMC