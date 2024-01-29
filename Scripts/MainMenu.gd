extends Node2D

var current_chapter = -1
var chapter_node

# Called when the node enters the scene tree for the first time.
func _ready():
	load_chapter(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func load_chapter(chapter):
	if (current_chapter == chapter):
		return
		
	if (chapter != -1):
		remove_child(chapter_node)
	chapter_node = load("res://Chapter" + str(chapter) + ".tscn").instantiate()
	add_child(chapter_node)
	move_child(chapter_node, 0)
	current_chapter = chapter

func to_options():
	get_tree().change_scene_to_file("res://Settings.tscn")
