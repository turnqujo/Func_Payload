# Func_Payload

**Note that there's still quite a bit left to be done on this. It will likely have breaking changes soon.**

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

## Thanks
Thanks to GeckonCZ, Nero, H2Whoa, and others for helping answer a bunch of questions. This code draws a lot of inspiration from GeckonCZ's vehicles code in `th_hunger`, as well as Valve's `func_tracktrain` code.

## Usage
I put this code under an MIT license, but if you do happen to use the code for something else, I'd like to hear about it!
