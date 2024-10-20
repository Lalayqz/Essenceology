extends Node2D

var chapter_bar_width
var map_node = null
@onready var chapter_bar = get_node("ChaptersBar")


func _ready():
	if not Save.is_any_chapter_solved():
		chapter_bar.visible = false
	chapter_bar_width = chapter_bar.size.x if chapter_bar.visible else 0
	load_chapter(Global_Variables.current_chapter)	


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Save.save_game()
		get_tree().quit()
func _process(delta):
	pass

func input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)


func load_chapter(chapter):
	if (map_node != null):
		remove_child(map_node)
	
	Global_Variables.set_chapter(chapter)
	Lights.update_color_to_chapter_color(chapter)
	
	map_node = load("res://scenes/maps/" + chapter + ".tscn").instantiate()
	add_child(map_node)
	move_child(map_node, 0)
	map_node.position = Vector2(chapter_bar_width, 0)
	# NOT get_viewport().size! get_viewport().size is actially the window size, not viewport size.
	map_node.size = Vector2(Vector2(get_viewport().content_scale_size) - map_node.position)
	
	# set map position
	var drag_position = Global_Variables.get_map_drag_pos()
	if drag_position != null:
		map_node.set_pos(drag_position)
	else: # set view to focus point
		var pos = Vector2(map_node.size / 2) - map_node.focus_position
		map_node.set_pos(pos)


func to_settings():
	get_tree().change_scene_to_file("res://scenes/menus/settings.tscn")
	Lights.update_color_to_chapter_color("SETTINGS")
