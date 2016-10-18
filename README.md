# CastModifier

This addon allows you to use a small subset of the macro conditionals, first introduced in the TBC expansion, in your 1.12.1 Vanilla client.

Demo video:

[![Example Video](https://img.youtube.com/vi/xHTe4Df77MY/0.jpg)](https://www.youtube.com/watch?v=xHTe4Df77MY)

### Installation

  - [Download](http://www.wow-one.com/forum/topic/13808-introducing-classic-mouseover-cm/) Classic Mouseover and put it into your `WoW/Interface/AddOns` folder.
  - [Download](https://github.com/DennisWG/CastModifier/archive/master.zip) the latest version of CastModifier directly from the repository and extract it into your `WoW/Interface/AddOns/` folder.
  - Rename `CastModifier-master` to `CastModifier`
  - Run World of Warcraft and make sure to enable this addon in the character select screen

## Conditionals

### Branching

Since every Conditional may fail, it might be desirable to have the ability to specify an alternative Conditional to check or a fallback ability to cast. This allows the user to chain together a set of Conditionals in an 'if-else' equivalent branch. For example:
```lua
/cast [mod:ctrl] Healing Wave; Healing Wave (Rank 1)
```
If CTRL is pressed the highest rank of Healing Wave will be casted. If it isn't rank 1 will be casted instead. You may chain together as many Conditionals as you want by just separating them with semicolons:
```lua
/cast [mod:ctrl] Healing Wave; [mod:alt] Windfury Totem; [mod:shift] Healing Wave (Rank 3); Frost Shock
```

Note, that you may use any spell you want within each Conditional. Also, there mustn't be a whitespace character after each semicolon. You may use them to improve readability.

### mod:ctrl/shift/alt

Modifier keys are a convenient way to save action bar space and make certain decisions.

Example:
```lua
/cast [mod:ctrl] Healing Wave; Healing Wave (Rank 1)
```

This will cast your highest rank of Healing Wave whenever you have the CTRL key pressed, otherwise Healing Wave rank 1.

### help / harm

The [help] condition is true when the unit can receive a beneficial effect, e.g., a healing spell. The [harm] condition is true when the unit would get an adverse effect, e.g., a damaging spell.

Example:
```lua
/cast [harm] Frost Shock; [help] Healing Wave
```

This will cast Frost Shock on hostile targets and Healing Wave on friendly targets.

### @[UnitID](http://wow.gamepedia.com/index.php?title=UnitId&oldid=204442)

Sets the target of the spell. Can be any valid Unit ID, including 'mouseover'. However, 'mouseover' currently still requires the use of the ClassicMouseover addon. I'll integrate this part into the addon if I ever find the time for it.

Example:
```lua
/cast [harm @target] Frost Shock; [help @mouseover] Healing Wave
```

You will cast Frost Shock on your current target if it is considered hostile. If it isn't and your mouseover target is considered friendly, your character will cast Healing Wave on your mouseover target instead.

### stance:0[/1/.../n]

Allows you to check whether or not you are in the given stance / shapeshift form. To check for multiple stances, separate their numbers with `/`. Stance numbers start at the left most stance with the number 1. Number 0 means you are in no stance.

Example (Druids):
```lua
/cast [stance:1] Enrage; Dire Bear Form
```
This macro will cast Enrage if you are in your (Dire) Bear Form. If not it will go into said Form.

Example (Warriors):
```lua
/cast [stance:1/2] Shield Bash; Defensive Stance
```
If you are in either the Battle Stance or the Defensive Stance, you will cast Shield Bash. If you are in the Berserker Stance, however, you will switch into Defensive Stance.

### [no]stealth

The Conditional will only pass when your character is stealthed. May be inverted by adding `no` in front of `stealth`.

Example:
```lua
/cast [stealth @player] Healing Touch; Shadowmeld
```

If your character is stealthed, he or she will cast Healing Touch. If your character is not stealthed, Shadowmeld will be cast instead.

### [no]combat

May only be used in combat. Can be inverted by adding `no` in front of `combat`.

Example:
```lua
/cast [nocombat] Starfire; Wrath
```

Your Oomkin will cast Starfire when you are not in combat, as an opener and Wrath afterward.

### Combining Conditionals

In the previous examples, I've made use of the feature of combining Conditionals. You're able to combine one Conditional of each category to create an 'and' equivalent conjunction, by adding additional Conditionals, separated by white spaces, into the brackets.

Example:
```lua
/cast [mod:ctrl harm @player] Holy Light
```

You will only cast Holy Light if you have CTRL pressed and the target is hostile. It will also target your character.

### Gray button fix:

In order to fix the range and cooldown check (gray buttons), you have to write this line at the top of each macro:

`/script if nil then CastSpellByName("SPELLNAME"); end`

Make sure to replace `SPELLNAME` with the actual name of your spell.

Example:
```lua
/script if nil then CastSpellByName("Chain Heal"); end
/cast [@target help mod:alt] Chain Heal; Chain Heal(Rank 1)
```

### Todos

 - Write Tests
 - Implement proper mouseover targeting
 - Add Code Comments

License
----

MIT
