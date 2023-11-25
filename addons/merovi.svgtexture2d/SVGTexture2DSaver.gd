@tool
extends ResourceFormatSaver
class_name SVGTexture2DFormatSaver

func _recognize(resource):
	var canRecognize = resource is SVGTexture2D
	if canRecognize:
		return true
	return false

func _recognize_path(resource, path):
	return path.ends_with(".sex")

func _get_recognized_extensions(resource):
	return PackedStringArray(["sex"])

func _save(resource, path, flags):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Can't create file: ", path)
		return ERR_CANT_CREATE
	
	# Write the headers for our SVG Extension File.
	file.store_8("S".to_ascii_buffer()[0])
	file.store_8("E".to_ascii_buffer()[0])
	file.store_8("X".to_ascii_buffer()[0])
	file.store_8(0x1) # Version 1.
	
	# Write the frames for the svg.
	var frames = (resource as SVGTexture2D).svg_data_frames
	file.store_32(frames.size())
	for i in range(frames.size()):
		var svg_data = (resource as SVGTexture2D).svg_data_frames[i].to_utf8_buffer()
	
		# Compress the data
		var svg_data_compressed = PackedByteArray(svg_data).compress()
	
		# Write the lengths of the compressed data
		file.store_32(svg_data_compressed.size())
		
		# Write the lengths of the uncompressed data
		file.store_32(svg_data.size())
		
		# Write the compressed data
		file.store_buffer(svg_data_compressed)
	
	file.close()
	return OK
