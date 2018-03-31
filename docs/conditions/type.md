# type

Checks whether the target of our action has the given CreatureTypeId.

## Parameters

These CreatureTypeIds are available:

* Beast
* Critter
* Demon
* Dragonkin
* Elemental
* Giant
* Humanoid
* Mechanical
* Not_Specified
* Totem
* Undead

You may also use your respective localized names instead.

**Note:** I've taken the localized names from the legion version of wowwiki, so they may be incorrect. If you spot any mistakes, please forward the correctly localized names to me!

## Examples

```lua
/cast [@target type:Beast] Hibernate; Entangling Roots
```

Will cast Hibernate if your current target is a Beast. If not Entangling Roots will be cast instead.
