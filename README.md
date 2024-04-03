# SVG Rasterization Plugin for Godot 4.2

This Godot plugin provides the functionality to re-rasterize vector assets at runtime, offering crisp and clear vector images regardless of camera zoom. This is advantageous over traditional mipmaps, which can result in blurry images when scaled.

## Requirements

Godot 4.2 or newer.

## Features

### SVGTexture2D Resource

This custom resource type allows for importing SVG files directly into Godot. It's designed to handle both single SVG images and animations.

#### Properties

* `svg_data_frames`: An array of strings, each containing the contents of an SVG file for each frame.
* `frames_import_dimensions`: An array of Vector2, specifying the width and height dimensions for each frame.

#### Single Frame

Single-frame `SVGTexture2D` resources can be created by importing SVG files directly. The plugin makes a single-frame `SVGTexture2D` from it.

#### Animation

Animations are defined in a separate .json file with the following format. Note that each frame path is relative to the .json animation manifest file:

```json
{
    "frames": [
        "path/to/frame0.svgtex",
        "path/to/frame1.svgtex",
        "path/to/frame2.svgtex"
    ]
}

```

### SVGSprite2D Node (Derived from `Sprite2D`)

A custom node that uses the SVGTexture2D resource to display SVGs in your scenes. It listens for scale changes and re-rasterizes its texture accordingly to always present a clear image. Note that it always uses frame[0] so you can use that to crop the SVG image or even create an atlas SVG file.

#### Properties

* SVGTexture: The `SVGTexture2D` resource that this node displays.
* Sprite Size: The physical size of the sprite on the screen. If you set this number to 1.0, it's equal to the original dimensions of the file. 2.0 makes it twice the size on screen. Changing this re-rasterizes the texture.
* Resolution: The sub-pixel depth of each of the sprite. If you set this number to 1.0, it means for each pixel rendered on screen, the texture has 1 pixel. If you set it to > 1.0, you can effectively zoom into the texture without losing quality. Used for SVGCamera2D zooming. Changing this re-rasterizes the texture.

### SVGAnimatedSprite2D Node (Derived from `AnimatedSprite2D`)

An animated sprite node that allows playing animations defined in the SVGTexture2D resource. It automatically plays the "default" animation and also listens to scale changes to re-rasterize frames for clarity.

#### Properties

* SVGTexture: The `SVGTexture2D` resource containing the animation frames.
* Sprite Size: The physical size of the sprite on the screen. If you set this number to 1.0, it's equal to the original dimensions of the file. 2.0 makes it twice the size on screen. Changing this re-rasterizes each frame of the texture.
* Resolution: The sub-pixel depth of each of the sprite. If you set this number to 1.0, it means for each pixel rendered on screen, the texture has 1 pixel. If you set it to > 1.0, you can effectively zoom into the texture without losing quality. Used for SVGCamera2D zooming. Changing this re-rasterizes each frame of the texture.

### SVGCamera2D Node (Derived from `Camera2D`)

This is an extended Camera2D that automatically handles zooming based on viewport resizes. It works similar to the stretch mode, but it's behavior is a bit more what you'd expect for a resize. Note that it also fires off a zoom_changed signal that `SVGSprite2D` and `SVGAnimatedSprite2D` nodes hook into for automatically re-rasterizing based on camera zoom.

#### Signals

* Zoom Changed: Triggered any time the viewport is resized and, therefore, the camera's zoom has changed.

## Purpose

The primary objective of this plugin is to tackle the problem of blurry rasterized assets when zooming in a game. Traditional rasterized assets, when scaled, especially in engines like Godot, can get blurry due to the use of mipmaps. This plugin provides a solution by allowing assets to be re-rasterized during runtime based on the current scale, ensuring that your SVG assets remain sharp and clear, regardless of the camera's zoom level.

## Installation

1. Download or clone the plugin.
2. Copy the plugin's folder into the addons folder of your Godot project.
3. Go to `Project` > `Project Settings` > `Plugins` and enable the SVG Rasterization Plugin.

## Usage

I've configured the plugin to expect your svg files to have the extension "svgtex". This fixes a bug where the plugin attempts to import as Texture2D first and you have to re-import it. Inkscape can still open the files as .svgtex extension, you just have to click "All Files." If someone knows a way to tell Godot to use SVGTexture2D before Texture2D on imports, please feel free to put a PR up.

In the Godot editor, drag and drop your SVGTEX file into the FileSystem tab.

When prompted for the import settings, select `SVGTexture2D` from the Import dropdown.

Your SVG is now imported as an `SVGTexture2D` resource. You can use it with `SVGSprite2D` or `SVGAnimatedSprite2D` nodes in your scenes.

You can then add an `SVGCamera2D` and you should be able to resize the game and see your `SVGSprite2D` assets automatically accounting for the change in zoom.

## License

This project is licensed under the Apache License 2.0.