@tool
extends AnimatedSprite2D
class_name SVGAnimatedSprite2D

const SVGCamera2D = preload("svg_camera_2d.gd")
const SVGTexture2D = preload("svg_texture_2d.gd")

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
		# Store the state of the current sprite.
		var was_playing = is_playing()
		var current_frame = get_frame()
		
		var frames = SpriteFrames.new()
		for i in range(SVGTexture.svg_data_frames.size()):
			var image = _rasterize_svg(SVGTexture.svg_data_frames[i], sprite_size * Resolution)
			var texture = ImageTexture.new()
			texture.set_image(image)
			frames.add_frame("default", texture)
		self.sprite_frames = frames
		
		set_frame(current_frame)
		if was_playing:
			play()
	scale = Vector2(1.0 / Resolution, 1.0 / Resolution)

func _rasterize_svg(data, scale):
	var image = Image.new()
	image.load_svg_from_string(data, scale)
	image.fix_alpha_edges()
	return image
	
