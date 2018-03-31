# UnitID

An identifier that refers to a unit int he game world that can be interacted
with. Available identifiers are:

* `@player` - The current player (You!)
* `@pet` - The current player's pet
* `@partyN` - The Nth party member excluding the player (N is 1, 2, 3 or 4)
* `@partypetN` - The pet of the Nth party member (N is 1, 2, 3 or 4)
* `@raidN` - The Nth raid member (N is 1, 2, 3, ..., 40)
* `@raidpetN` - The pet of the Nth raid member (N is 1, 2, 3, ..., 40)
* `@target` - The currently targetted unit
* `@mouseover` - The unit which the mouse is currently hovering over (May be
incompatible with some unit frames. Refer to the [Compatibility Notes](/../compatibility.md).
* `@npc` - The NPC with which the player is currently interacting.

You may append `target` to any of these to refer to that unit's target. You may
even chain them together like `@playertargettargettarget`, but you'll notice an
attendant performance hit if you overdo it.

## Examples

```lua
/cast [harm @target] Frost Shock; [help @mouseover] Healing Wave
```

You will cast Frost Shock on your current target if it is considered hostile.
If it isn't and your mouseover target is considered friendly, your character
will cast Healing Wave on your mouseover target instead.

---

```lua
/cast [@mouseover] Flash Heal; [@focus] Flash Heal
```

Casts Flash Heal if you have a mouseover target. Casts Flash Heal on your focus
target if you don't (Refer to the [Compatibility Notes](/../compatibility.md)).
