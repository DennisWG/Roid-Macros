# stance

Allows you to check whether or not you are in the given stance or shapeshift
form.

## Parameters

May take a number of parameters seperated by slashes `/`.

* 0 - You're in no stance
* 1, 2, ..., n - You're in stance 1, 2, ..., n where n is the total number of
stances or shapeshift form availlable

## Examples

```lua
/cast [stance:0] Cat Form
```

Enter Cat Form when not shapeshifted.

---

```lua
/cast [stance:1] Enrage; Dire Bear Form
```

This macro will cast Enrage if you are in your (Dire) Bear Form. If not it will
go into said Form.

---

```lua
/cast [stance:1/2] Shield Bash; Defensive Stance
```
If you are in either the Battle Stance or the Defensive Stance, you will cast
Shield Bash. If you are in the Berserker Stance, however, you will switch into
Defensive Stance.
