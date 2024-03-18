@tool
extends EditorPlugin

var dock

func _enter_tree():
	dock = preload("res://addons/cursecord/cursecord.tscn").instance()
	add_control_to_dock(DOCK_SLOT_RIGHT_UR, dock)

func _input(event):
	var scene_root = get_tree().get_edited_scene_root()
	var mouse_coords = scene_root.get_global_mouse_position()
	#dock.set_text(str(mouse_coords))
	print(mouse_coords)

func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()
