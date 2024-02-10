extends Node2D

@onready var CHAPTER = Global_Variables.current_chapter
@onready var CHAINS = $Chains
@onready var LEVELS = $Levels
var LEVEL_CHAINS = {Global_Variables.Chapters.Possibility:[["INTRO", "UNLIKELY"], ["UNLIKELY", "LOGIC"], ["LOGIC", "LOGIC_HARD"], ["LOGIC", "LIES_GENERALIZED"], ["LIES_GENERALIZED", "LIES_1"], ["LIES_1", "LIES_2"], ["LIES_2", "LIES_HARD"]]}
var UNSOLVED_LEVEL_TEXTURE = preload("res://Resources/Unsolved_Level.png")
var SOLVED_LEVEL_TEXTURE = preload("res://Resources/Solved_Level.png")
var LEVEL_ICON_RADIUS = UNSOLVED_LEVEL_TEXTURE.get_width() / 2
var LEVEL_LABEL_FONT = preload("res://Resources/SourceHanSansSC-Normal.otf")
var LABEL_FONT_SIZE = 23
var LABEL_OFFSET_Y = -3
var drag_start = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# calculate levels_unlocked and chains_not_unlocked (only "key" of the dict is used)
	var chains_unlocked = {}
	var levels_not_unlocked = {}
	for chain in LEVEL_CHAINS[CHAPTER]:
		if Save.get_level_solved(CHAPTER, chain[0]):
			chains_unlocked[chain] = 1
		levels_not_unlocked[chain[1]] = 1
	var levels_unlocked_in_not_unlocked = []
	for level in levels_not_unlocked:
		var is_unlocked = true
		for chain in LEVEL_CHAINS[CHAPTER]:
			if chain[1] == level and not Save.get_level_solved(CHAPTER, chain[0]):
				is_unlocked = false
				break
		if is_unlocked:
			levels_unlocked_in_not_unlocked.append(level)
	for level in levels_unlocked_in_not_unlocked:
		levels_not_unlocked.erase(level)
	# remove not-unlocked levels
	for level in levels_not_unlocked:
		LEVELS.remove_child(LEVELS.get_node(level))
	# add chains
	for chain in chains_unlocked:
		var level_start = LEVELS.get_node(chain[0])
		if level_start == null:
			continue
		var level_end = LEVELS.get_node(chain[1])
		var points = PackedVector2Array([level_start.position, level_end.position])
		var chain_node = load("res://Item_Scenes/Chain.tscn").instantiate()
		chain_node.points = points
		chain_node.get_child(0).points = points
		CHAINS.add_child(chain_node)
	# add level icons
	for level in LEVELS.get_children():
		var level_sprite = Sprite2D.new()
		level_sprite.texture = SOLVED_LEVEL_TEXTURE if Save.get_level_solved(CHAPTER, level.name) else UNSOLVED_LEVEL_TEXTURE
		level.add_child(level_sprite)
		var level_label = load("res://Item_Scenes/UI_Text.tscn").instantiate()
		var label_size = LEVEL_LABEL_FONT.get_string_size(level.name, 0, -1, LABEL_FONT_SIZE)
		level_label.text = level.name
		level_label.position.y -= (LEVEL_ICON_RADIUS + label_size.y / 2 + LABEL_OFFSET_Y)
		level_label.set("theme_override_font_sizes/font_size", LABEL_FONT_SIZE)
		level_label.set("theme_override_colors/font_shadow_color", Global_Variables.current_chapter_color)
		level.add_child(level_label)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	var is_motion = event is InputEventMouseMotion
	var is_press = event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT
	var is_release = event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT
	if (is_motion):
		for level in LEVELS.get_children():
			if (event.position.distance_to(level.global_position) <= LEVEL_ICON_RADIUS):
				level.get_child(0).modulate = Color.GRAY
			else:
				level.get_child(0).modulate = Color.WHITE
	elif (is_release and event.position.distance_to(drag_start) <= LEVEL_ICON_RADIUS):
		for level in LEVELS.get_children():
			if (event.position.distance_to(level.global_position) <= LEVEL_ICON_RADIUS):
				get_tree().change_scene_to_file("res://Levels/" + Global_Variables.Chapters.keys()[CHAPTER] + "/" + level.get_name() + ".tscn")
	elif (is_press):
		drag_start = event.position
					
