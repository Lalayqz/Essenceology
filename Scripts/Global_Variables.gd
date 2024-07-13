extends Node

var FINALES = {"POSSIBILITY":["FINALE"]}
var current_chapter
var current_chapter_color
var maps_drag_pos = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_chapter(chapter):
	current_chapter = chapter
	match chapter:
		"POSSIBILITY":
			current_chapter_color = 0x55ff55ff
		"SHOULD":
			current_chapter_color = 0x5555ffff
		"DEFINITION":
			current_chapter_color = 0xffaa00ff
	
func is_finale(chapter, level):
	return chapter in FINALES and level in FINALES[chapter]	
			
func set_map_drag_pos(pos, chapter = current_chapter):
	maps_drag_pos[chapter] = pos
	
func get_map_drag_pos(chapter = current_chapter):
	if chapter in maps_drag_pos:
		return maps_drag_pos[chapter]
	return Vector2(0, 0)
