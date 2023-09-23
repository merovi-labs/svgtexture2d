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
	var frames = []
	for i in range(num_frames):
		var x = file.get_float()
		var y = file.get_float()
		var z = file.get_float()
		var w = file.get_float()
		frames.push_back(Vector4(x, y, z, w))
	
	var svg_length = file.get_32()
	var svg_uncompressed_length = file.get_32()
	
	var svg_compressed_data = file.get_buffer(svg_length)
	var svg_data_uncompressed = svg_compressed_data.decompress(svg_uncompressed_length)
	var svg_data = svg_data_uncompressed.get_string_from_utf8()
	
	var custom_resource = SVGTexture2D.new()
	custom_resource.svg_data = svg_data
	custom_resource.frames = frames
	file.close()
	
	return custom_resource
