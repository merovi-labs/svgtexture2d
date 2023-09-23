@tool
extends EditorImportPlugin
class_name SVGTexture2DEditorImportPlugin

func _get_importer_name():
	return "merovi.svgtexture2d"

func _get_visible_name():
	return "SVGTexture2D"

func _get_recognized_extensions():
	return ["svg"]

func _get_resource_type():
	return "SVGTexture2D"

func _get_preset_count():
	return 1

func _get_preset_name(preset_index):
	return "Default"
	
func _get_import_options(path, preset_index):
	var options = [{
		"name": "frames",
		"default_value": [Vector4(0, 0, 1.0, 1.0)],
		"property_hint": PROPERTY_HINT_ARRAY_TYPE
	}]
	return options

func _get_option_visibility(path, option_name, options):
	return true
	
func _get_priority():
	return 1.0

func _get_import_order():
	return 0

func _get_save_extension():
	return "sex"

func _import(source_file, save_path, options, platform_variants, gen_files):
	var file = FileAccess.open(source_file, FileAccess.READ)
	if file == null:
		return FAILED
	
	var resource = SVGTexture2D.new()
	resource.svg_data = file.get_as_text()
	resource.frames = options["frames"]
	
	var file_path = save_path + "." + _get_save_extension()
	if ResourceSaver.save(resource, file_path, 0) != OK:
		push_error("Uh oh! @ ", file_path)
		push_error(ResourceSaver.get_recognized_extensions(resource))
		return ERR_FILE_CANT_WRITE
	
	file.close()
	return OK
