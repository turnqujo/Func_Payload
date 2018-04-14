# Func_Payload
Version 1.0

## Installing
- Clone the repo into your svencoop_addon/scripts/maps/{your_map}/ directory.
- Include `func_payload`.
- Call the `FuncPayload::Register` method on `MapInit`.

  Example:
  ```
  #include "func_payload/func_payload"

  void MapInit() {
    FuncPayload::Register();
  }
  ```
- Add the `func_payload.fgd` to the list of game configurations in Hammer or your preferred editor.
- Create a brush entity (with an origin brush) of type `func_payload`.
- Add some `path_track` entities, as if the `func_payload` was a `func_tracktrain`.
- Keep in mind that the payload will determine what is friendly or not by checking classifications. If you want a "friendly" payload, I'd suggest using the `human passive` option.
- Have fun!

## Property Descriptions (Customization)
- Detection Radius
  - The radius of the circle around the payload's origin which is used to detect entities.
- Friendly glow color
  - When entities friendly to the payload are in range, they will glow this color.
- Enemy glow color
  - Same as the friendly glow color, except for enemies.
- Speed multiplier per friendly
  - Each friendly entity in range beyond the first will increase the payload's speed by this much, converted to a percentage (e.g. `0.2` is `20%`).
- Max number of multiplies
  - Limit for how many times to increase the payload's speed by the multiplier, beyond the first. If set to `0`, the payload won't increase speed.
- Max speed
  - Limit the speed of the payload to this amount. The speed multiplier properties above will only raise the speed up to this maximum if they reach it.
- Amount to heal or hurt friendlies in range
  - Positive values will heal the friendly entities, negative will hurt them. This value will apply each second the entity is in range.
- Amount to heal or hurt enemies in range
  - Functionally the same as the friendly version, but applied to enemies in range.
- Spawnflags
  - Disable friendly glow
    - The payload won't apply the glow affect to friendly units in range.
  - Disable enemy glow
    - the payload won't apply the glow affect to enemy units in range.

## trigger_payload_mode
This is a point entity which allows you to change the movement state of the payload. Movement states change how the payload decides to move.
- Normal
  - This mode will advance forward _only_ when assisted by friendly units _and_ when no enemy units are in range.
- Force move
  - This mode will advance forward, not stopping regardless of what entities are within range. It will still heal / hurt and apply glowing effects.
- Force stop
  - The payload will remain stationary, and will not start moving until its movement state has been changed to `Normal` or `Force Move`. It will still heal / hurt and apply glowing effects.

## Technical Details
This entity was written with pretty heavy use of AngelScript's `mixin` classes. In order to keep things sane, the mixin classes all have a single, isolated purpose; for example, the `Sound Manager` mixin class is _only_ responsible for anything sound-related. Code outside of the `Sound Manager` can interact with it through the methods it "exposes" (the ones not marked with `private`).

The mixin classes are tied together by the main `CFuncPayload` class, which calls out to the other mixins when appropriate.

I tried to break things out as cleanly as I could, so that others (and myself!) could reference this work if they want to make a similar entity. Perhaps a mixin class could even be brought into another entity and used without much configuration.

## Thanks
Thanks to GeckonCZ, Nero, H2Whoa, and others for helping answer a bunch of questions. This code draws a lot of inspiration from GeckonCZ's vehicles code in `th_hunger`, as well as Valve's `func_tracktrain` code.

## Usage
I put this code under an MIT license, but if you do happen to use the code for something else, I'd like to hear about it!
