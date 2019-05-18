--[[
	Author: Dennis Werner Garske (DWG)
	License: MIT License
]]
local _G = _G or getfenv(0)
local Roids = _G.Roids or {}

-- A list of all registered extensions
Roids.Extensions = Roids.Extensions or {};

-- Calls the "OnLoad" function of every extension
function Roids.InitializeExtensions()
    for k, v in pairs(Roids.Extensions) do
        local func = v["OnLoad"];
        if not func then
            Roids.Print("Roids.InitializeExtensions - Couldn't find 'OnLoad' function for extension "..k);
        else
            func();
        end 
    end
end

-- Removes the given hook
-- hook: The hook to remove
function Roids.RemoveHook(hook)
    _G[hook.name] = hook.origininal;
end

-- Removes the given hook from the given object
-- object: The object to remove the hook from
-- hook: The hook to remove
function Roids.RemoveMethodHook(object, hook)
    object[hook.name] = hook.origininal;
end

-- Clears all previously declared hooks
function Roids.ClearHooks()
    for k, v in pairs(Roids.Extensions) do
        for k2, v2 in pairs(v.internal.memberHooks) do
            for k3, v3 in pairs(v2) do
                Roids.RemoveMethodHook(k2, v3);
            end
        end
        
        for k2, v2 in pairs(v.internal.hooks) do
            Roids.RemoveHook(v2);
        end
    end
end

-- Creates a new extension with the given name
-- name: the name of the extension
function Roids.RegisterExtension(name)    
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
        Roids.RegisterEvent(name, eventName, callbackName);
    end;
    
    extension.Hook = function(functionName, callbackName, dontCallOriginal)
        Roids.RegisterHook(name, functionName, callbackName, dontCallOriginal);
    end;
    
    extension.HookMethod = function(object, functionName, callbackName, dontCallOriginal)
        Roids.RegisterMethodHook(name, object, functionName, callbackName, dontCallOriginal);
    end;
    
    
    extension.UnregisterEvent = function(eventName, callbackName)
        Roids.UnregisterEvent(name, eventName, callbackName);
    end;
    
    extension.internal.OnEvent = function()
        local callbackName = extension.internal.eventHandlers[event];
        if callbackName then
            extension[callbackName]();
        end
    end;
    
    
    -- This is a function wrapper that we swap with the function that we want to hook
    -- @return Value of Callback() or Origininal() if dontCallOriginal is false
    extension.internal.OnHook = function(object, functionName, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
        local hook;
        
        if object then
            hook = extension.internal.memberHooks[object][functionName];
        else
            hook = extension.internal.hooks[functionName];
        end
        
        local retval = hook.callback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
        if not hook.dontCallOriginal then
            retval = hook.origininal(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
        end
        return retval
    end;
    
    
    extension.internal.frame:SetScript("OnEvent", extension.internal.OnEvent);
    
    Roids.Extensions[name] = extension;
    
    return extension;
end

-- Registers a callback function for a given event name
-- extensionName: The name of the extension trying to register the callback
-- eventName: The event's name we'd like to register a callback for
-- callbackName: The name of the callback that get's called when the event fires
function Roids.RegisterEvent(extensionName, eventName, callbackName)
    local extension = Roids.Extensions[extensionName];
    extension.internal.eventHandlers[eventName] = callbackName;
    extension.internal.frame:RegisterEvent(eventName);
end

-- Hooks the given function by it's name
-- extensionName: The name of the extension trying to register the callback
-- functionName: The name of the function that'll be hooked
-- callbackName: The name of the callback that get's called when the hooked function is called
-- dontCallOriginal: Set to true when the original function should not be called
function Roids.RegisterHook(extensionName, functionName, callbackName, dontCallOriginal)
    local orig = _G[functionName];
    local extension = Roids.Extensions[extensionName];
    
    if not orig then
        Roids.Print("Roids.RegisterHook - Invalid function to hook: "..functionName)
    end
    
    if not extension then
        Roids.Print("Roids.RegisterHook - Invalid extension: "..extension);
        return;
    end
    
    if not extension[callbackName] then
        Roids.Print("Roids.RegisterHook - Couldn't find callback: "..callbackName);
        return;
    end
    
    
    extension.internal.hooks[functionName] = {
        origininal = orig,
        callback = extension[callbackName],
        name = functionName,
        dontCallOriginal = dontCallOriginal
    };
    
    _G[functionName] = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
        return extension.internal.OnHook(nil, functionName, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
    end;
end

-- Hooks the given object's function
-- object: The object you want to hook
-- extensionName: The name of the extension trying to register the callback
-- functionName: The name of the function that'll be hooked
-- callbackName: The name of the callback that get's called when the hooked function is called
function Roids.RegisterMethodHook(extensionName, object, functionName, callbackName, dontCallOriginal)
    if not object then
        Roids.Print("Roids.RegisterMethodHook - The object could not be found!");
        return;
    end

    if type(object) ~= "table" then
        Roids.Print("Roids.RegisterMethodHook - The object needs to be a table!");
        return;
    end
    
    local orig = object[functionName];
    
    if not orig then
        Roids.Print("Roids.RegisterMethodHook - The object doesn't have a function named "..functionName);
        return;
    end
    
    local extension = Roids.Extensions[extensionName];
    
    if not extension then
        Roids.Print("Roids.RegisterMethodHook - Invalid extension: "..extension);
        return;
    end
    
    if not extension[callbackName] then
        Roids.Print("Roids.RegisterMethodHook - Couldn't find callback: "..callbackName);
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
        return extension.internal.OnHook(object, functionName, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
    end;
end

function Roids.UnregisterEvent(extensionName, eventName, callbackName)
    local extension = Roids.Extensions[extensionName];
    if extension.internal.eventHandlers[eventName] then
        extension.internal.eventHandlers[eventName] = nil;
        extension.internal.frame:UnregisterEvent(eventName);
    end
end

_G["Roids"] = Roids
