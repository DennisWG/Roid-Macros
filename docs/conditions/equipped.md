# equipped

Ensures that the given item type is equipped.

## Parameters

May take a single parameter from the following list:

* Daggers - Looks for a dagger in your mainhand
* Fists - Looks for a fist weapon in your mainhand
* Axes - Looks for an axe in your mainhand
* Swords - Looks for a sword in your mainhand
* Staffs - Looks for a staff in your mainhand
* Maces - Looks for a mace in your mainhand
* Polearms - Looks for a polearm in your mainhand
* Shields - Looks for a shield in your offhand
* Guns - Looks for a gun in your ranged slot
* Crossbows - Looks for a crossbow in your ranged slot
* Bows - Looks for a cow in your ranged slot
* Thrown - Looks for a thrown weapon in your ranged slot
* Wands - Looks for a wand in your ranged slot

## Examples

```lua
/cast [equipped:Bows] Shoot Bow; [equipped:Crossbows] Shoot Crossbow; [equipped:Guns] Shoot Gun; [equipped:Thrown] Throw
```

Will use your ranged shoot ability depending on what ranged weapon you
currently have equipped.
