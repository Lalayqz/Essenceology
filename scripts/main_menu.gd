extends Node2D

var chapter_bar_width
var map_node = null
@onready var window_size = get_viewport().size
@onready var chapter_bar = get_node("ChaptersBar")


func _ready():
	if not Save.is_any_chapter_solved():
		chapter_bar.visible = false
	chapter_bar_width = chapter_bar.size.x if chapter_bar.visible else 0
	load_chapter(Global_Variables.current_chapter)	


func input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)


func _notification(notification):
	if notification == NOTIFICATION_WM_CLOSE_REQUEST:
		Save.save_game()
		get_tree().quit()


func load_chapter(chapter):
	if (map_node != null):
		remove_child(map_node)
	
	Global_Variables.set_chapter(chapter)
	Lights.update_color_to_chapter_color(chapter)
	
	map_node = load("res://scenes/maps/" + chapter + ".tscn").instantiate()
	var window_pos = Vector2(chapter_bar_width, 0)
	var window_size = Vector2(get_viewport().size) - window_pos
	map_node.set_window_info(window_pos, window_size)
	add_child(map_node)
	move_child(map_node, 0)
	Global_Variables.current_chapter = chapter
	
	# set map position
	var drag_position = Global_Variables.get_map_drag_pos()
	if drag_position != null:
		map_node.position = drag_position
	else: # set view to focus point
		var map_window_size = window_size
		map_window_size.x = map_window_size.x - chapter_bar_width
		var pos = Vector2(map_window_size / 2) - map_node.focus_position + Vector2(chapter_bar_width, 0)
		map_node.set_pos(pos)


func to_settings():
	get_tree().change_scene_to_file("res://scenes/menus/settings.tscn")
	Lights.update_color_to_chapter_color("SETTINGS")
