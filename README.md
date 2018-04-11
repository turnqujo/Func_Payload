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
- Have fun!

## Usage
I put this code under an MIT license, but if you do happen to use the code for something else, I'd like to hear about it!
