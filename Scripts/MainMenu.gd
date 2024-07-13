extends Node2D

@onready var CHAPTER_BAR = get_node("Chapters_Bar")
var current_chapter = null
var chapter_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if not Save.is_any_chapter_solved():
		CHAPTER_BAR.visible = false
	load_chapter("POSSIBILITY")

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
	if (current_chapter == chapter):
		return
	if (chapter_node != null):
		remove_child(chapter_node)
	
	Global_Variables.set_chapter(chapter)
	Lights.update_color_to_chapter_color(chapter)
	
	chapter_node = load("res://Scenes/Maps/" + chapter + ".tscn").instantiate()
	add_child(chapter_node)
	move_child(chapter_node, 0)
	current_chapter = chapter

func to_settings():
	get_tree().change_scene_to_file("res://Scenes/Settings.tscn")
	Lights.update_color_to_chapter_color("SETTINGS")
