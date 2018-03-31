# [my]power / [my]rawpower

Checks whether or not you (mypower) or the specified target (power) has the
given amount of its power type.

## Parameters

A less than `<` or greater than `>` sign followed by the amount of actual power
([my]rawpower) or the percentage ([my]power) that is required.

## Examples

```lua
/cast [mypower>60] Heroic Strike
```

Will cast Heroic Strike when you have more than 60% rage.

---

```lua
/cast [harm @target power>10] Mana Burn
```

Will cast Mana Burn as long as your current target has more than 10% power.

---

```lua
/cast [myrawpower<390] Arcane Explosion(Rank 1); Arcane Explosion
```

Will cast max rank Arcane Explosion as long as you have the mana to do so and
will cast Arcane Explosion Rank 1 when you don't.
