@tool

extends ResourceFormatLoader
class_name SVGTexture2DFormatLoader

func _get_recognized_extensions():
	return PackedStringArray(["sex"])

func _get_resource_type(path):
	if path.ends_with(".sex"):
		return "SVGTexture2D"
	return ""

func _handles_type(type):
	return type == "SVGTexture2D"

func _rasterize_svg(data, scale):
	var image = Image.new()
	image.load_svg_from_string(data, scale)
	return image

func _load(path, original_path, use_sub_threads, cache_mode):
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return null
	
	# Check the headers for our SVG Extension File.
	var header = file.get_buffer(4)
	if header.size() < 4 or header[0] != "S".to_ascii_buffer()[0] or header[1] != "E".to_ascii_buffer()[0] or header[2] != "X".to_ascii_buffer()[0] or header[3] != 0x1:
		file.close()
		return null
	
	# Handle the frames.
	var num_frames = file.get_32()
	var frame_data = []
	var frames_import_dimensions = []
	for i in range(num_frames):
		var svg_length = file.get_32()
		var svg_uncompressed_length = file.get_32()
		var svg_compressed_data = file.get_buffer(svg_length)
		var svg_data_uncompressed = svg_compressed_data.decompress(svg_uncompressed_length)
		frame_data.push_back(svg_data_uncompressed.get_string_from_utf8())
	
	# Now let's get the original dimensions by creating temporary rasterizations
	# This isn't stored in the file, we will just have to calculate it.
	for i in range(num_frames):
		# Let's load the image once just to store off the original dimensions
		var image = _rasterize_svg(frame_data[i], 1.0)
		frames_import_dimensions.push_back(image.get_size())
	
	var custom_resource = SVGTexture2D.new()
	custom_resource.svg_data_frames = frame_data
	custom_resource.frames_import_dimensions = frames_import_dimensions
	file.close()
	
	return custom_resource
