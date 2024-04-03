@tool
extends StyleBoxTexture
class_name SVGStyleBoxTexture

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

func _ready():
	_update_texture()

func _update_texture():
	if SVGTexture:
		var image = _rasterize_svg(SVGTexture.svg_data_frames[0], Resolution)
		var texture = ImageTexture.new()
		texture.set_image(image)
		self.texture = texture

func _rasterize_svg(data, scale):
	var image = Image.new()
	image.load_svg_from_string(data, scale)
	image.fix_alpha_edges()
	return image
