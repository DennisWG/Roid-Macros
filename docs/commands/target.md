# A few words about /target macros

In theory, you can use every condition, however, a few of them behave a little
different in '/target' macros. Here's a list of them:

## Definitions

A few definitions before we start:
##### final target 
The unit that will be selected after evaluating every condition. E.g.
`/target Ragnaros` - Ragnaros will be the `final target`.

##### checked target
The unit against which all conditions will be checked. E.g.
`/target [harm @mouseover] Ragnaros` - Your current mouseover target will be
the `checked target` while `Ragnaros` is still the `final target`.

----

As stated before, instead of checking the final target, all conditions will
be validated against the checked target. This means that your checked target
may or may not be the same as your final target. This allows you to create more
specialized macros and, on top of that, is more intuitive to use.

## Examples

```lua
/target [harm @mouseover] Ragnaros; Dotalock
```

This will target Ragnaros, if your mouseover target is hostile to yourself. If
it isn't the player Dotalock will be targeted instead.


Additionally, assume you want to target your mouseover target depending on
whether or not some pre-conditions are met. In Vanilla WoW, there is no way to
do something like that. With this AddOn, however, we can do things like this:

```lua
/target [harm @target] @targettarget
```

When you use this macro, you will target your target's target, if your current
target is considered hostile towards you.

## Known issues

Assume you're assaulting a capital like Orgrimmar or Stormwind and you have a
macro like the following:

```lua
/target [harm @mouseover] @mouseover
```

Now you're trying to use this macro to select one of the city's guards that is
a fair bit away from you. Because of the way the Vanilla client implements
targeting by names, you're not guaranteed to target your mouseover target. This
will always happen when another unit with the same name is closer to you than
the desired unit. There is no way to work around this issue, as the actual
targeting procedure hasn't been implemented in Lua and is therefore out of
reach for AddOn developers.
