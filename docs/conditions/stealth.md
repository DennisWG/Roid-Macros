# stealth / nostealth

The condition will only pass when your character is stealthed. May be inverted by adding `no` in front of `stealth`.

## Example

```lua
/cast [stealth @player] Healing Touch; Shadowmeld
```

If your character is stealthed, he or she will cast Healing Touch. If your character is not stealthed, Shadowmeld will be cast instead.
