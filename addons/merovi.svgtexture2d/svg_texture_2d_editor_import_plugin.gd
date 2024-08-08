@tool
extends EditorImportPlugin
class_name SVGTexture2DEditorImportPlugin

const SVGTexture2D = preload("svg_texture_2d.gd")

func _get_importer_name():
	return "merovi.svgtexture2d"

func _get_visible_name():
	return "SVGTexture2D"

func _get_recognized_extensions():
	return ["svgtex", "svgsc", "svg", "svgseq", "json"]

func _get_resource_type():
	return "SVGTexture2D"

func _get_preset_count():
	return 1

func _get_preset_name(preset_index):
	return "Default"
	
func _get_import_options(path, preset_index):
	return []

func _get_option_visibility(path, option_name, options):
	return true
	
func _get_priority():
	return 1.0

func _get_import_order():
	return 0

func _get_save_extension():
	return "sex"

func _import_single_svg(source_file, save_path):
	var file = FileAccess.open(source_file, FileAccess.READ)
	if file == null:
		return FAILED
	
	var resource = SVGTexture2D.new()
	resource.svg_data_frames.push_back(file.get_as_text())
	
	var file_path = save_path + "." + _get_save_extension()
	if ResourceSaver.save(resource, file_path, 0) != OK:
		push_error("Uh oh! @ ", file_path)
		push_error(ResourceSaver.get_recognized_extensions(resource))
		return ERR_FILE_CANT_WRITE
	
	file.close()
	return OK

func _import_animation_sequence(source_file, save_path):
	var metadata = JSON.new()
	var file = FileAccess.open(source_file, FileAccess.READ)
	if file == null:
		push_error("Unable to find source file for animation sequence.")
		return FAILED
		
	var base_path = source_file.get_base_dir()
	if not base_path.ends_with("/"):
		base_path += "/"
	
	var error = metadata.parse(file.get_as_text())
	file.close()
	if error != OK:
		push_error("Unable to read animation sequence.")
		return ERR_FILE_CORRUPT
	var metadata_result = metadata.get_data()
	
	var resource = SVGTexture2D.new()
	if "frames" in metadata_result and typeof(metadata_result["frames"]) == TYPE_ARRAY:
		var frames_array = metadata_result["frames"]
		for frame_path in frames_array:
			var relative_file_path = base_path + frame_path.strip_edges()
			var svg_file = FileAccess.open(relative_file_path, FileAccess.READ)
			if svg_file == null:
				push_error("Unable to find requested frame.")
				return FAILED
			resource.svg_data_frames.push_back(svg_file.get_as_text())
			svg_file.close()
	else:
		push_error("Invalid or missing 'frames' key in Animation Sequence file.")
		return ERR_FILE_CORRUPT
	
	var file_path = save_path + "." + _get_save_extension()
	if ResourceSaver.save(resource, file_path, 0) != OK:
		push_error("Uh oh! @ ", file_path)
		push_error(ResourceSaver.get_recognized_extensions(resource))
		return ERR_FILE_CANT_WRITE
	
	file.close()
	return OK

func _import(source_file, save_path, options, platform_variants, gen_files):
	var extension = source_file.get_extension().to_lower()
	
	match extension:
		"svgsc":
			return _import_single_svg(source_file, save_path)
		"svgtex":
			return _import_single_svg(source_file, save_path)
		"svg": # Backwards compatibility
			return _import_single_svg(source_file, save_path)
		"svgseq":
			return _import_animation_sequence(source_file, save_path)
		"json": # Backwards compatibility
			return _import_animation_sequence(source_file, save_path)
	return OK
