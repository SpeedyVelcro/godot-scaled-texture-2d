# ScaledTexture2D
`ScaledTexture2D` is a `Resource` for Godot Engine 4.2 that displays a texture at a fixed size.

Typically if you need a texture to show at a certain size, you would prefer to do the scaling somewhere else such as on a Sprite2D. This resource is for the edge case where you know the size you want to display the texture at, but you **do not know** the size of the texture itself. This situation may arise if you are trying to support user-made texture packs using [resource pack loading](https://docs.godotengine.org/en/stable/tutorials/export/exporting_pcks.html). In such a case, users may want to create create high-resolution texture packs to support higher zoom levels in your game, or low-resolution texture packs to save memory.

## Installation
Follow the [instructions](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html) in the Godot Docs.

## Usage
- Create a new ScaledTexture2D
    - You can do this inline in the Inspector when setting the texture for e.g. a Sprite2D, a TileSet, etc.
- Set the texture
- Set the size

## License
See [`LICENSE.md`](LICENSE.md)

