extends "Button.gd"

@onready var SAVE_NODE = get_node("/root/Save")
@onready var BACKGROUND = get_node("..")
@onready var LEVEL_NAME = get_node("../../..").name
@onready var INPUTS = get_tree().get_nodes_in_group("Inputs")
var HOLD_TIME = 1
var WIDTH = self.size.x
var BACKGROUND_PROGRESS_SPEED = float(WIDTH) / HOLD_TIME
var inputs
var background_width = 0
var is_held_down = false

# Called when the node enters the scene tree for the first time.
func _ready():
	check_all_answered()
	
func _process(delta):
	if is_held_down:
		background_width += delta * BACKGROUND_PROGRESS_SPEED
		if background_width >= WIDTH:
			check_answer()
			return_normal()
		BACKGROUND.size.x = background_width

func return_normal():
	self.modulate = Color.WHITE
	background_width = 0
	BACKGROUND.size.x = background_width
	is_held_down = false

func hovered():
	self.modulate = Color.GRAY
	
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
			return
	solve_level()
	
func solve_level():
	SAVE_NODE.set_level_solved(LEVEL_NAME)
	self.visible = false
	for input in INPUTS:
		input.disabled = true
