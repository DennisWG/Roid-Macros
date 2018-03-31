# Conditions

Conditions allow you to fine-tune your macro's behaviour without having to
know any Lua at all!

---

# Notation

```lua
/command [condition] parameters
```

Conditions are put after the chat command but before the chat command's
parameters into square brackets.

---

```lua
/command [condition1 condition2] parameters
```

Conditions can be chained together by seperating them using an empty space. All
conditions must be met before the command is executed.

---

```lua
/command [condition:parameter] parameters
```

Some conditions may take parameters. These follow after a colon `:` or, in
some cases, after a greater than `>` or less than `<` sign.

---

```lua
/command [condition:1/2/3] parameters
```

Some conditions may take multiple parameters. These have to be seperated by
slashes `/`.

# Branches

When using conditions in your macros, it might be desirable to perform two
different actions that depend on both outcomes of a condition. While you could
in theory achieve this by repeating the inverted condition one line below,
you'll realise that this would lead to making your macros exceedingly bigger.
An example:

```lua
/cast [dead] Spell1
/cast [nodead] Spell2
```

Roid-Macros solves this by allowing you to branch off of the first set of
parameters, if the conditions fails, by seperating them with a semicolon `;` at
the end. The same example but now with a branch instead:

```lua
/cast [dead] Spell1; Spell2
```

Of course you could also put in more conditons in the different branches!

```lua
/cast [condition1] Healing Wave; [condition2] Windfury Totem; [condition3] Healing Wave (Rank 3); Frost Shock
```

Note, that you may use any spell you want within each condition. Also, there
mustn't be a whitespace character after each semicolon. You may, however, use
them to improve readability.

---

# Supported Chat Commands

This is a list of all Chat Commands that support conditions:

* /cast
* /target
* [/equip](commands/equip.md)
* [/equipoh](commands/equip.md)
* [/petattack](commands/petattack.md)
* [/unshift](commands/unshift.md)
* [/use](commands/use.md)

---

# Available Conditoins:
* [attacks / noattacks](conditions/attacks.md)
* [(no)buff / (no)mybuff / (no)debuff / (no)mydebuff](conditions/buffs.md)
* [channeled / nochanneled](conditions/channeled.md)
* [combat / nocombat](conditions/combat.md)
* [cooldown / nocooldown](conditions/cooldown.md)
* [dead / nodead](conditions/dead.md)
* [equipped](conditions/equipped.md)
* [group](conditions/group.md)
* [help / harm](conditions/help_harm.md)
* [(my)hp](conditions/hp.md)
* [isnpc](conditions/isnpc.md)
* [isplayer](conditions/isplayer.md)
* [mod](conditions/mod.md)
* [party](conditions/party.md)
* [(my)power / (my)rawpower](conditions/power.md)
* [raid](conditions/raid.md)
* [stance](conditions/stance.md)
* [stealth / nostealth](conditions/stealth.md)
* [type](conditions/type.md)
* [UnitID](conditions/target.md)
