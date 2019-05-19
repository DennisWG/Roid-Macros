# mod

Modifier keys are a convenient way to save action bar space and make certain
decisions.

## Parameters

May take a number of parameters seperated by slashes `/`.

* ctrl - the CTRL key is pressed down
* shift - the SHIFT key is pressed down
* alt - the ALT key is pressed down

## Examples:

```lua
/cast [mod:ctrl] Renew; [nomod @focus] Heal; Flash Heal
```

This will cast Renew on your Target if CTRL is pressed. If that fails it will try to cast
Heal at your Focus target if you have one and no modifier keys are pressed. In all other cases
it will cast Flash Heal

---

```lua
/cast [mod:ctrl/shift] Healing Wave
```

You will cast Healing Wave when you have CTRL and SHIFT pressed.
