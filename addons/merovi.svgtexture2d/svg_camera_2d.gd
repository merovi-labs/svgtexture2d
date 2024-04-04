@tool
extends Camera2D
class_name SVGCamera2D

var base_viewport_size = Vector2(0, 0)
var original_zoom = Vector2(1, 1)

signal zoom_changed(new_zoom)

# Called when the node enters the scene tree for the first time.
func _ready():
	var size = get_viewport().size
	base_viewport_size = Vector2(size.x, size.y)
	original_zoom = zoom
	get_viewport().size_changed.connect(_on_viewport_resize)

func _on_viewport_resize():
	var new_size = get_viewport().size
	_adjust_zoom(Vector2(new_size.x, new_size.y))
	zoom_changed.emit(get_zoom_percent())

func _adjust_zoom(viewport_size: Vector2):
	var old_aspect_ratio = base_viewport_size.x / base_viewport_size.y
	var new_aspect_ratio = viewport_size.x / viewport_size.y
	
	if new_aspect_ratio > old_aspect_ratio:
		# Wider than the original aspect ratio
		zoom.x = viewport_size.y / base_viewport_size.y
		zoom.y = zoom.x
	else:
		# Taller than the original aspect ratio
		zoom.y = viewport_size.x / base_viewport_size.x
		zoom.x = zoom.y

func get_zoom_percent() -> float:
	return zoom.x / original_zoom.x
