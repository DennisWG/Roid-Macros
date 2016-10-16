# CastModifier

This addon allows you to use a small subset of the macro conditionals, first introduced in the TBC expansion, in your 1.12.1 Vanilla client.

Demo video:

[![Example Video](https://img.youtube.com/vi/R5wtyhUbaLs/0.jpg)](https://www.youtube.com/watch?v=YOUTUBE_VIDEO_ID_HERE)

### Installation

  - [Download](https://github.com/DennisWG/CastModifier/archive/master.zip) the latest version of CastModifier directly from the repository and extract it into your `WoW/Interface/AddOns/` folder.
  - Rename `CastModifier-master` to `CastModifier`
  - Run World of Warcraft and make sure to enable this addon in the character select screen

## Conditionals

### mod:ctrl/shift/alt

Modifier keys are a convenient way to save action bar space and make certain decisions.

Example:
```lua
/cast [mod:ctrl] Healing Wave
/cast Healing Wave (Rank 1)
```

This will cast your highest rank of Healing Wave whenever you have the CTRL key pressed, otherwise Healing Wave rank 1.

### help / harm

The [help] condition is true when the unit can receive a beneficial effect, e.g., a healing spell. The [harm] condition is true when the unit would get an adverse effect, e.g., a damaging spell.

Example:
```lua
/cast [harm] Frost Shock
/cast [help] Healing Wave
```

This will cast Frost Shock on hostile targets and Healing Wave on friendly targets.

### target=[UnitID](http://wow.gamepedia.com/index.php?title=UnitId&oldid=204442)

Sets the target of the spell. Can be any valid Unit ID, including 'mouseover'. However, 'mouseover' currently still requires the use of the ClassicMouseover addon. I'll integrate this part into this addon if I ever find the time for it.

Example:
```lua
/cast [harm target=target] Frost Shock
/cast [help target=mouseover] Healing Wave
```

You will cast Frost Shock on your current target if it is considered hostile. If it isn't and your mouseover target is considered friendly, your character will cast Healing Wave on your mouseover target instead.


### Todos

 - Write Tests
 - Implement proper mouseover targeting
 - Add Code Comments
 - Implement Blizzard's way of proper Conditional branching (e.g. `/cast [harm] Frost Shock; [help] Healing Wave`)

License
----

MIT

