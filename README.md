# CastModifier

This addon allows you to use a small subset of the macro conditionals, first introduced in the TBC expansion, in your 1.12.1 Vanilla client.

Demo videos:

[![Example Video](https://img.youtube.com/vi/xHTe4Df77MY/0.jpg)](https://www.youtube.com/watch?v=xHTe4Df77MY)

[![Example Video2](https://img.youtube.com/vi/0w5nePeJlPU/0.jpg)](https://www.youtube.com/watch?v=0w5nePeJlPU)

### Installation

  - Make sure ClassicMouseover is no longer installed or disable it in the character select screen!
  - [Download](https://github.com/DennisWG/CastModifier/archive/master.zip) the latest version of CastModifier directly from the repository and extract it into your `WoW/Interface/AddOns/` folder.
  - Rename `CastModifier-master` to `CastModifier`
  - Run World of Warcraft and make sure to enable this addon in the character select screen

## Channelled spells and auto attack

If you do not want to re-cast a channelled spell until it is finished, you can ensure that the spell finishes by putting an exclamation mark in front of the spell's name.

Example:
```lua
/cast !Mind Flay
```

This also works for auto attacks:
```lua
/cast !Attack
```

You may now spam this button to cast Mind Flay whenever it's done casting.

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

Sets the target of the spell. Can be any valid Unit ID, including 'mouseover'. However, 'mouseover' requires additional work in order to work with every UnitFrame AddOn that exists. Please refer to https://github.com/DennisWG/CastModifier/wiki/UnitFrames-Compatibility for more information.

Example:
```lua
/cast [harm @target] Frost Shock; [help @mouseover] Healing Wave
```

You will cast Frost Shock on your current target if it is considered hostile. If it isn't and your mouseover target is considered friendly, your character will cast Healing Wave on your mouseover target instead.

Additionally, this AddOn interoperates with ClassicFocus, allowing you to use @focus when you have that AddOn installed!

Example:
```lua
/cast [@mouseover] Flash Heal; [@focus] Flash Heal
```

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

### equipped

Ensures that the given item type is equipped. Item type may be one of the following:

  - Daggers - Looks for a dagger in your mainhand
  - Fists - Looks for a fist weapon in your mainhand
  - Axes - Looks for an axe in your mainhand
  - Swords - Looks for a sword in your mainhand
  - Staffs - Looks for a staff in your mainhand
  - Maces - Looks for a mace in your mainhand
  - Polearms - Looks for a polearm in your mainhand
  - Shields - Looks for a shield in your offhand
  - Guns - Looks for a gun in your ranged slot
  - Crossbows - Looks for a crossbow in your ranged slot
  - Bows - Looks for a cow in your ranged slot
  - Thrown - Looks for a thrown weapon in your ranged slot
  - Wands - Looks for a wand in your ranged slot

Example:
```lua
/cast [equipped:Bows] Shoot Bow; [equipped:Crossbows] Shoot Crossbow; [equipped:Guns] Shoot Gun; [equipped:Thrown] Throw
```

Will use your ranged shoot ability depending on what ranged weapon you currently have equipped.

### [no]dead

May only be used when your target is dead. Can be inverted by adding `no` in front of `dead`.

Example:
```lua
/cast [dead] Resurrection; Flash Heal
```

Will cast Resurrection if your current target is dead. If it isn't you will cast Flash Heal instead.

Example:
```lua
/cast [nodead] Flash Heal; Resurrection
```

The same as above just with `nodead`.

### party

The Conditional will only fire when your target is in your party.

Example:
```lua
/cast [party] Arcane Brilliance; Arcane Intellect
```

This macro will cast Arcane Brilliance when your current target is in your party. If your target isn't, it will cast Arcane Intellect on it instead.

### raid

The Conditional will only fire when your target is in your raid.

Example:
```lua
/cast [raid] Arcane Brilliance; Arcane Intellect
```

This macro will cast Arcane Brilliance when your current target is in your raid. If your target isn't, it will cast Arcane Intellect on it instead.

### group:party/raid

The Conditional will only fire when you're in a party or raid.

Example:
```lua
/cast [group:party] Arcane Brilliance; [group:raid] Arcane Intellect
```

This macro will cast Arcane Brilliance when you are in a party. It will cast Arcane Intellect instead when you are in a raid.

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

License
----

MIT
