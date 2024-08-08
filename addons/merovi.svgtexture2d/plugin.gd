@tool
extends EditorPlugin

const SVGTexture2D = preload("svg_texture_2d.gd")
const SVGTexture2DEditorImportPlugin = preload("svg_texture_2d_editor_import_plugin.gd")

var import_plugin:SVGTexture2DEditorImportPlugin

func _handles(_object):
	return _object is SVGTexture2D

func _enter_tree():
	var svg_icon = load("res://addons/merovi.svgtexture2d/svg_icon.png")
	import_plugin = preload("svg_texture_2d_editor_import_plugin.gd").new()
	add_custom_type("SVGCamera2D", "Camera2D",
		preload("svg_camera_2d.gd"), 
		svg_icon)
	add_custom_type("SVGSprite2D", "Sprite2D",
		preload("svg_sprite_2d.gd"), 
		svg_icon)
	add_custom_type("SVGAnimatedSprite2D", "AnimatedSprite2D",
		preload("svg_animated_sprite_2d.gd"), 
		svg_icon)

	add_import_plugin(import_plugin)
	

func _exit_tree():
	remove_import_plugin(import_plugin)
	remove_custom_type("SVGCamera2D")
	remove_custom_type("SVGSprite2D")
	remove_custom_type("SVGAnimatedSprite2D")

	import_plugin = null
