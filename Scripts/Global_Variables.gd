extends Node

var FINALES = {"POSSIBILITY":["FINALE"], "SHOULD":["FINALE"]}
var CHAPTER_COLORS = {"POSSIBILITY": 0x55ff55ff, "SHOULD": 0xffaa00ff, "DEFINITION": 0x5555ffff}
var CHAPTER_BACKGROUND_COLORS = {"POSSIBILITY": 0x081a08ff, "SHOULD": 0x190f00ff}
var current_chapter = "POSSIBILITY"
var current_chapter_color
var current_chapter_background_color
var maps_drag_pos = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_chapter(chapter):
	current_chapter = chapter
	current_chapter_color = CHAPTER_COLORS[chapter]
	current_chapter_background_color = CHAPTER_BACKGROUND_COLORS[chapter]
	
func is_finale(chapter, level):
	return chapter in FINALES and level in FINALES[chapter]	
			
func set_map_drag_pos(pos, chapter = current_chapter):
	maps_drag_pos[chapter] = pos
	
func get_map_drag_pos(chapter = current_chapter):
	if chapter in maps_drag_pos:
		return maps_drag_pos[chapter]
	return null
