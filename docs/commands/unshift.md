# /unshift

`/unshift` make you leave your shapeshift form.

## Examples

```lua
/unshift [stance:1/2/4]
```
This macro will cause you to exit your shapeshift form if you're either in [Dire] Bear Form, Aquatic Form, or Travel Form.

---

```lua
/unshift [stance:1/2/4]
/cast [stance:0] Cat Form; [nocombat nostealth] Prowl
```
You will exit any form other than Cat Form. Then, if you're not shapeshifted, you'll go into Cat Form. If you are in Cat Form you'll cast Prowl.