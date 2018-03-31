# [my]hp

Checks whether or not you (myhp) or the specified target (hp) has the given amount of hit points.

## Parameters

A less than `<` or greater than `>` sign followed by the percentage of hp that
is required.

## Examples

```lua
/cast [myhp<40 @player] Flash Heal; Flash heal
```

Will cast Flash Heal either on yourself, when you have less than 40% health, or
on your current target if you have more hp.

---

```lua
/cast [hp<20] Execute; Bloodthirst
```

Will cast Bloodthirst until your target has less than 20% health. At that point
the macro will only cast Execute.
