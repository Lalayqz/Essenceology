extends NeatButton

@onready var CHAPTER = Global_Variables.current_chapter
@onready var LEVEL_NAME = get_node("../../../..").name
@onready var BACKGROUND = get_node("../../Background")
@onready var INPUTS = get_tree().get_nodes_in_group("Inputs")
@onready var WIDTH = self.size.x
@onready var HOLD_TIME = 1
@onready var BACKGROUND_PROGRESS_SPEED = float(WIDTH) / HOLD_TIME
var SUBMIT_TEXT = "SUBMIT_HOLD"
var PENALTYS = [1, 3, 6, 10]
var inputs
var background_width = 0
var is_held_down = false

# Called when the node enters the scene tree for the first time.
func _ready():
	check_all_answered()
	update_penalty()
	
func _process(delta):
	if is_held_down:
		background_width += delta * BACKGROUND_PROGRESS_SPEED
		if background_width >= WIDTH:
			check_answer()
			return_normal()
		BACKGROUND.custom_minimum_size.x = background_width
	if self.disabled:
		update_penalty()

func update_penalty():
	var penalty = Save.get_level_penalty(CHAPTER, LEVEL_NAME)
	if penalty > 0:
		var penalty_int = int(ceil(penalty))
		self.disabled = true
		self.text = "🔒   " + "%02d:%02d" % [penalty_int / 60, penalty_int % 60]
	else:
		self.disabled = false
		self.text = SUBMIT_TEXT

func return_normal():
	self.modulate = Color.WHITE
	background_width = 0
	BACKGROUND.custom_minimum_size.x = background_width
	is_held_down = false
	
func button_down():
	self.modulate = Color.WEB_GRAY
	is_held_down = true
	
func check_all_answered():
	var all_answered = true
	for input in INPUTS:
		if input.is_not_answered():
			all_answered = false
			break
	self.visible = all_answered
	
func check_answer():
	for input in INPUTS:
		if not input.check_answer():
			self.disabled = true
			var fail = Save.get_level_fail(CHAPTER, LEVEL_NAME)
			var penalty = PENALTYS[fail] * 60 if fail < len(PENALTYS) else PENALTYS[-1] * 60
			Save.set_level_fail(CHAPTER, LEVEL_NAME, fail + 1)
			Save.set_level_penalty(CHAPTER, LEVEL_NAME, penalty)
			return
	solve_level()
	
func solve_level():
	Save.set_level_solved(CHAPTER, LEVEL_NAME)
	get_node("../../../..").save_inputs()
	self.visible = false
	for input in INPUTS:
		input.disabled = true
	var solved_label = get_node("../Solved_Label")
	solved_label.set("theme_override_colors/font_shadow_color", Global_Variables.current_chapter_color)
	solved_label.visible = true

func _on_input_state_changed():
	pass # Replace with function body.
