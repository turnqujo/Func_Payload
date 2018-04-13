# TODO

## Bugs
- Add in some code to prevent the payload from spinning wildly. Pitch is currently limited to 45 degrees, but it shouldn't be.

## Minor improvements
- More targeted `base()` use in the `.fgd` file.
- Mark methods on mixin classes which aren't intended to be called from outside code as private.

## Features
- Some way of triggering other entities (customizable) when the payload starts, stops, or otherwise changes state.
- Customizable payload sound
- Backwards movement, "roll-back" flag for `path_nodes` (or another approach).
- Customizable effects for assistants and blockers.
  - For example, healing or damage over time.
