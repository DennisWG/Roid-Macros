# [no]buff / [no]mybuff / [no]debuff / [no]mydebuff

Ensures that you (mybuff/mydebuff) or the specified target (buff/debuff) has
the given buff or debuff. May be inverted by adding a 'no' at the beginning.

## Parameters

The name of the buff or debuff. May be abbreviated and mustn't contain anything
that isn't a letter from the English alphabet. White spaces must be replaced by
an underscore `_`.

## Examples

```lua
/cast [nobuff:Fortitude @mouseover] Power Word: Fortitude
```

Will cast Power Word: Fortitude on your mouseover target if no such buff could be found on it.

---

```lua
/cast [mybuff:Blood_Fury] Healing Wave
```

Will cast Healing Wave on yourself only while Blood Fury is active.

---

```lua
/cast [debuff:Curse_of_Weakness @player] Healing Wave
```

Will cast Healing Wave on yourself as long as Curse of Weakness is active.