@tool
extends EditorPlugin

var importer : SVGTexture2DEditorImportPlugin

func _handles(object):
	return object is SVGTexture2D

func _enter_tree():
	importer = SVGTexture2DEditorImportPlugin.new()
	add_import_plugin(importer)

func _exit_tree():
	remove_import_plugin(importer)
	importer = null
