extends ReferenceRect

const ENTER_LEVEL_DRAG_MAX = 18
const LABEL_FONT_SIZE = 23
const LABEL_OFFSET_Y = -3
var visible_levels = []
var level_label_font = preload("res://resources/fonts/SourceHanSansSC-Normal.otf")
var unsolved_level_texture = preload("res://resources/images/unsolved_level.png")
var unsolved_finale_texture = preload("res://resources/images/unsolved_finale.png")
var drag_start = null
var drag_start_last_frame = null
@onready var chapter = GlobalVariables.current_chapter
@onready var map = $Map
@onready var background = map.get_node("Background")
@onready var chains = map.get_node("Chains")
@onready var levels = map.get_node("Levels")
@onready var focus_position = map.get_node("Focus").position
@onready var solved_level_texture = load("res://resources/images/solved_level_" + chapter + ".png")
@onready var solved_finale_texture = load("res://resources/images/solved_finale_" + chapter + ".png")


func _ready():
	# Levels that are at the end of a chain appears in this dictionary.
	# A value of True means the level is unlocked.
	var levels_to_be_unlocked = {}
	var visible_level_names = []
	var chains_unlocked = []
	for chain in LevelInfos.LEVEL_CHAINS[chapter]:
		var level = chain[1]
		var is_chain_unlocked = Save.get_level_solved(chapter, chain[0])
		
		if level in LevelInfos.LEVELS_UNLOCKED_BY_ALL_CHAINS[chapter]:
			if level not in levels_to_be_unlocked or levels_to_be_unlocked[level] == true:
				levels_to_be_unlocked[level] = is_chain_unlocked
		else:
			if level not in levels_to_be_unlocked or levels_to_be_unlocked[level] == false:
				levels_to_be_unlocked[level] = is_chain_unlocked
		
		if is_chain_unlocked:
			chains_unlocked.append(chain)
	
	# hide not-unlocked levels
	for level in levels.get_children():
		if level.name in levels_to_be_unlocked and levels_to_be_unlocked[level.name] == false:
			level.visible = false
		else:
			visible_levels.append(level)
			visible_level_names.append(level.name)
	# add chains
	for chain in chains_unlocked:
		var level_start = levels.get_node(chain[0])
		if level_start == null:
			continue
		var level_end = levels.get_node(chain[1])
		var points = PackedVector2Array([level_start.position, level_end.position])
		var chain_node
		
		if visible_level_names.has(chain[1]):
			chain_node = load("res://scenes/items/chain.tscn").instantiate()
		else:
			chain_node = load("res://scenes/items/dashed_chain.tscn").instantiate()
		
		chain_node.points = points
		chains.add_child(chain_node)
	# add level icons
	for level in visible_levels:
		var is_solved = Save.get_level_solved(chapter, level.name)
		var level_sprite = Sprite2D.new()
		if level.name in LevelInfos.FINALES[chapter]:
			level_sprite.texture = solved_finale_texture if is_solved else unsolved_finale_texture
		else:
			level_sprite.texture = solved_level_texture if is_solved else unsolved_level_texture
		level.add_child(level_sprite)
		var radius = level_sprite.texture.get_width() / 2
		var level_label = load("res://scenes/items/ui_text.tscn").instantiate()
		var label_size = level_label_font.get_string_size(level.name, HORIZONTAL_ALIGNMENT_LEFT, -1, LABEL_FONT_SIZE)
		level_label.text = '?  ?  ?' if level.name in LevelInfos.HIDDEN_NAME_LEVELS[chapter] and not is_solved else level.name
		level_label.position.y -= (radius + label_size.y / 2 + LABEL_OFFSET_Y)
		level_label.set("theme_override_font_sizes/font_size", LABEL_FONT_SIZE)
		level_label.set("theme_override_colors/font_outline_color", Color.WHITE)
		level_label.set("theme_override_colors/font_shadow_color", GlobalVariables.current_chapter_color)
		level.add_child(level_label)
		level.set_meta("Radius", radius)
	
	background.color = GlobalVariables.current_chapter_background_color


func _unhandled_input(event):  # use "unhandled" because I want the chapter bar to block map interactions.
	# Also, remember to set all control nodes' mouse filter (excluding charpter bar, but including the map itself) so the mouse action is unhandled when interacting with the map.
	var is_motion = event is InputEventMouseMotion
	var is_press = event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT
	var is_release = event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT
	# drag
	if (event is InputEventMouseButton):
		if (event.pressed):
			drag_start_last_frame = event.position
		else:
			drag_start_last_frame = null
	elif (is_motion):
		if (drag_start_last_frame != null):
			var pos = map.position + event.position - drag_start_last_frame
			set_pos(pos)
			drag_start_last_frame = event.position
			
	# enter level
	if (is_motion):
		for level in visible_levels:
			if (event.position.distance_to(level.global_position) <= level.get_meta("Radius")):
				level.get_child(0).modulate = Color.GRAY
			else:
				level.get_child(0).modulate = Color.WHITE
	elif (is_release and event.position.distance_to(drag_start) <= ENTER_LEVEL_DRAG_MAX):
		for level in visible_levels:
			if (event.position.distance_to(level.global_position) <= level.get_meta("Radius")):
				get_tree().change_scene_to_file("res://scenes/levels/" + chapter + "/" + level.get_name() + ".tscn")
	elif (is_press):
		drag_start = event.position


func set_pos(pos):
	map.position.x = max(pos.x, self.size.x - map.size.x)  # lower limit
	map.position.x = min(map.position.x, 0)  # upper limit
	map.position.y = max(pos.y, self.size.y - map.size.y)
	map.position.y = min(map.position.y, 0)


func _exit_tree():
	GlobalVariables.set_map_drag_pos(map.position)
