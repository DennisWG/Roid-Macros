# Invoking other Macros

This Addon provides you with the ability to invoke other Macros from within you
own Macros!

This allows for very interesting things like chaining together very complicated
Macros that each check for certain conditions before they are executed. To
execute another Macro, you have to put the name of the Macro in curly braces
`{` `}` after any chat command that is supported by this Addon.

### Example

Macro 1: `Master`
```lua
/cast {Blood}
/cast {WW}
/cast {Heroic}
```

Macro 2: `Blood`
```lua
/cast [mypower>30] Bloodthirst
```

Macro 3: `WW`
```lua
/cast [mypower>25] Whirlwind
```

Macro 4: `Heroic`
```lua
/cast [mypower>60 harm] Heroic Strike
```

You can now use Macro 1 `Master` to execute all the other Macros respectively.

## Invoking Macros may succeed or fail

The master Macro that attempts to execute another child Macro also knows
whether the executed Macro has succeeded if you're using conditions in the
child Macro. This allows you to build very complicated recursive constructs!

### Example

Macro 1: `Hawk`
```lua
/cast {Monkey}; [nomybuff:Aspect_of_the_Hawk] Aspect of the Hawk
```

Macro 2: `Monkey`
```lua
/cast [nomybuff:Aspect_of_the_Monkey] Aspect of the Monkey
```

When you now use Macro 1 `Hawk`, the macro will call Macro 2 `Monkey` and check
if it succeeded. Macro 2 will only succeed if the player doesn't have the
`Aspect of the Monkey` buff active. If he does, the Macro will fail and the
second part of Macro 1 `Hawk` will be executed!