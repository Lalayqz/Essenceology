extends Node2D

var current_chapter = null
var chapter_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	load_chapter(Global_Variables.Chapters.Possibility)

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
	Global_Variables.set_chapter(chapter)
		
	if (chapter_node != null):
		remove_child(chapter_node)
	chapter_node = load("res://Maps/" + Global_Variables.Chapters.keys()[chapter] + ".tscn").instantiate()
	add_child(chapter_node)
	move_child(chapter_node, 0)
	current_chapter = chapter

func to_options():
	get_tree().change_scene_to_file("res://Settings.tscn")
