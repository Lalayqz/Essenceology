extends Node2D

@onready var WINDOW_SIZE = get_viewport().size
@onready var CHAPTER_BAR = get_node("Chapters_Bar")
var CHAPTER_BAR_WIDTH
var map_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if not Save.is_any_chapter_solved():
		CHAPTER_BAR.visible = false
	CHAPTER_BAR_WIDTH = CHAPTER_BAR.size.x if CHAPTER_BAR.visible else 0
	load_chapter(Global_Variables.current_chapter)
	
	# set map position
	var drag_position = Global_Variables.get_map_drag_pos()
	if drag_position != null:
		map_node.position = drag_position
	else: # set view to focus point
		var map_window_size = WINDOW_SIZE
		map_window_size.x = map_window_size.x - CHAPTER_BAR_WIDTH
		var pos = Vector2(map_window_size / 2) - map_node.FOCUS_POSITION + Vector2(CHAPTER_BAR_WIDTH, 0)
		map_node.set_pos(pos)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
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
	
	map_node = load("res://Scenes/Maps/" + chapter + ".tscn").instantiate()
	var window_pos = Vector2(CHAPTER_BAR_WIDTH, 0)
	var window_size = Vector2(get_viewport().size) - window_pos
	map_node.set_window_info(window_pos, window_size)
	add_child(map_node)
	move_child(map_node, 0)
	Global_Variables.current_chapter = chapter

func to_settings():
	get_tree().change_scene_to_file("res://Scenes/Menus/Settings.tscn")
	Lights.update_color_to_chapter_color("SETTINGS")
