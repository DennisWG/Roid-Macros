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
/cast [mod:ctrl] Healing Wave; Healing Wave (Rank 1)
```

This will cast your highest rank of Healing Wave whenever you have the CTRL key pressed, otherwise Healing Wave rank 1.

---

```lua
/cast [mod:ctrl/shift] Healing Wave
```

You will cast Healing Wave when you have CTRL and SHIFT pressed.
