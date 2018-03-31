# dead / nodead

May only be used when your target is dead. Can be inverted by adding `no` in
front of `dead`.

## Examples:

```lua
/cast [dead] Resurrection; Flash Heal
```

Will cast Resurrection if your current target is dead. If it isn't you will cast Flash Heal instead.

---

```lua
/cast [nodead] Flash Heal; Resurrection
```

The same as above just the other way around.