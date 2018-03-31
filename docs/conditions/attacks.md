# attacks / noattacks

This condition will only fire when your target's target is [not] the
specified target.

## Parameters

The UnitID of the target that must [not] be attacking you. Refer to
[target condition](target.md)

## Examples

```lua
/cast [attacks:player] {Yes}; {No}
```

This will execute the Macro with the name `Yes`, if your target is currently
attacking you, and the Macro named `No` when it is not.