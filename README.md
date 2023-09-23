# SVG Rasterization Plugin for Godot 4.2

This Godot plugin provides the functionality to re-rasterize vector assets at runtime, allowing for crisp and clear vector images regardless of camera zoom. This offers an advantage over traditional mipmaps, which can often result in blurry images when scaled.

## Requirements

Godot 4.2 or newer.


## Features

### SVGTexture2D Resource

This is a custom resource type that allows you to import SVG files directly into Godot.

#### Properties

* svg_data: Contains the SVG data of the imported file.
* frames: A list of frames for animations, defined by their crop areas. A frame is represented as a four-float-tuple containing x, y, width, height, all as percentages of the original width/height of the SVG.

### SVGSprite2D Node (Derived from `Sprite2D`)

A custom node that uses the SVGTexture2D resource to display SVGs in your scenes. It listens for scale changes and re-rasterizes its texture accordingly to always present a clear image. Note that it always uses frame[0] so you can use that to crop the SVG image or even create an atlas SVG file.

#### Properties

* SVGTexture: The `SVGTexture2D` resource that this node displays.
* Scale: The scale at which the SVG is rasterized. Changing this will re-rasterize the SVG.

### SVGAnimatedSprite2D Node (Derived from `AnimatedSprite2D`)

An animated sprite node that allows playing animations defined in the SVGTexture2D resource. It automatically plays the "default" animation and also listens to scale changes to re-rasterize frames for clarity.

#### Properties

* SVGTexture: The `SVGTexture2D` resource containing the animation frames.
* Scale: The scale at which the SVG is rasterized. Changing this will re-rasterize the SVG Animation for each frame.

## Purpose

The primary objective of this plugin is to tackle the problem of blurry rasterized assets when zooming in a game. Traditional rasterized assets, when scaled, especially in engines like Godot, can get blurry due to the use of mipmaps. This plugin provides a solution by allowing assets to be re-rasterized during runtime based on the current scale, ensuring that your SVG assets remain sharp and clear, regardless of the camera's zoom level.

## Installation

1. Download or clone the plugin.
2. Copy the plugin's folder into the addons folder of your Godot project.
3. Go to `Project` > `Project Settings` > `Plugins` and enable the SVG Rasterization Plugin.

## Usage

In the Godot editor, drag and drop your SVG file into the FileSystem tab.

When prompted for the import settings, select `SVGTexture2D` from the Import dropdown.

Your SVG is now imported as an `SVGTexture2D` resource. You can use it with `SVGSprite2D` or `SVGAnimatedSprite2D` nodes in your scenes.

## License

This project is licensed under the Apache License 2.0.