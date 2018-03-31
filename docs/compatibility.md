# Compatibility Notes

## UnitFrames

Currently, the following UnitFrames have been tested and are compatible with
this AddOn:

* agUnitFrames
* Blizzard's UnitFrames
* CT_RaidAssist
* CT_UnitFrames
* DiscordUnitFrames
* FocusFrame
* Grid
* LunaUnitFrames
* NotGrid
* PerfectRaid
* pfUI
* sRaidFrames
* UnitFramesImproved_Vanilla
* XPerl

**Note**: If your AddOn is not on this list, please give it a try anyway! I've
implemented this in a way where it very well might work in your UnitFrames
AddOn as well! And if it doesn't please file an Issue and I'll try to add it asap.

## Action Bars

Currently, the following Action Bars have been tested and are compatible with
this Addon:

* Blizzard's Action Bars
* Discord Action Bars

**Note**: If your AddOn is not on this list, please give it a try anyway! I've
implemented this in a way where it very well might work in your Action Bars
AddOn as well! And if it doesn't please file an Issue and I'll try to add it asap.

## Supported Addons

### ClassicFocus / FocusFrame

Using one of these two Addons allows you to make use of the `@focus` target
condition!

## Known Bugs and work arounds

## Gray button fix

In order to fix the range and cooldown check (gray buttons), you have to write
this line at the top of each macro:

```lua
/script if nil then CastSpellByName("SPELLNAME"); end
```

Make sure to replace SPELLNAME with the actual name of your spell.

```lua
/script if nil then CastSpellByName("Chain Heal"); end
/cast [@target help mod:alt] Chain Heal; Chain Heal(Rank 1)
```

---

**Note:** There is currently no way to make this work for different spells
depending on conditions.

```lua
/script if nil then CastSpellByName("Chain Heal"); end
/cast [@target help] Chain Heal; Frost Shock
```

This will only activate the range and cooldown check for Chain Heal and not
check Frost Shock at all! This appears to be a limitation with the API and I
don't see a way of fixing this. Please contact me if you do!
