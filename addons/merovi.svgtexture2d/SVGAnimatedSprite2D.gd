@tool
extends AnimatedSprite2D
class_name SVGAnimatedSprite2D

@export var SVGTexture: SVGTexture2D = null:
	get:
		return SVGTexture
	set(value):
		SVGTexture = value
		_update_texture()

@export var Scale: float = 1.0:
	get:
		return Scale
	set(value):
		Scale = value
		_update_texture()

func _update_texture():
	if SVGTexture:
		var frames = SpriteFrames.new()
		for i in range(SVGTexture.frames.size()):
			var image = _rasterize_svg(SVGTexture.svg_data, Scale, SVGTexture.frames[i])
			var texture = ImageTexture.new()
			texture.set_image(image)
			frames.add_frame("default", texture)
		self.sprite_frames = frames

func _rasterize_svg(data, scale, frameData):
	var image = Image.new()
	image.load_svg_from_string(data, scale)
	frameData *= Vector4(image.get_width(), image.get_height(), image.get_width(), image.get_height())
	var cropped = Image.create(frameData.z, frameData.w, false, image.get_format())
	cropped.blit_rect(image, Rect2i(frameData.x, frameData.y, frameData.z, frameData.w), Vector2(0, 0))
	return cropped
