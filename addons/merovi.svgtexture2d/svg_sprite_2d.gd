@tool
extends Sprite2D
class_name SVGSprite2D

@export var SVGTexture: SVGTexture2D = null:
	get:
		return SVGTexture
	set(value):
		SVGTexture = value
		_update_texture()

@export var Resolution: float = 1.0:
	get:
		return Resolution
	set(value):
		Resolution = value
		_update_texture()

@export var sprite_size : float = 1.0:
	get:
		return sprite_size
	set(value):
		sprite_size = value
		_update_texture()

@export var auto_resize : bool = true

func _ready():
	var camera = get_viewport().get_camera_2d()
	if camera and camera is SVGCamera2D:
		(camera as SVGCamera2D).zoom_changed.connect(_on_zoom_change)
		_on_zoom_change(camera.get_zoom_percent())

func _on_zoom_change(zoom):
	if not auto_resize:
		return
	Resolution = zoom

func _update_texture():
	if SVGTexture:
		var image = _rasterize_svg(SVGTexture.svg_data_frames[0], sprite_size * Resolution)
		var texture = ImageTexture.new()
		texture.set_image(image)
		self.texture = texture
	scale = Vector2(1.0 / Resolution, 1.0 / Resolution)

func _rasterize_svg(data, scale):
	var image = Image.new()
	image.load_svg_from_string(data, scale)
	image.fix_alpha_edges()
	return image
	
