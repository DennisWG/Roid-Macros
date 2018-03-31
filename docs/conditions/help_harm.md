# help / harm

The [help] condition is true when the unit can receive a beneficial effect,
e.g., a healing spell. The [harm] condition is true when the unit would get an
adverse effect, e.g., a damaging spell.

## Example:

```lua
/cast [harm] Frost Shock; [help] Healing Wave
```

This will cast Frost Shock on hostile targets and Healing Wave on friendly targets.