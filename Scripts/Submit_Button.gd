extends Node2D

signal submit
@onready var CHAPTER = Global_Variables.current_chapter
@onready var BACKGROUND = get_node("Background")
@onready var BUTTON = get_node("Button/Button")
@onready var WIDTH = BUTTON.size.x
@onready var HOLD_TIME = 1
@onready var BACKGROUND_PROGRESS_SPEED = float(WIDTH) / HOLD_TIME
var LEVEL_NAME
var SUBMIT_TEXT = "SUBMIT_HOLD"
var background_width = 0
var is_held_down = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	if is_held_down:
		background_width += delta * BACKGROUND_PROGRESS_SPEED
		if background_width >= WIDTH:
			submit.emit()
			return_normal()
		BACKGROUND.custom_minimum_size.x = background_width
	if BUTTON.disabled:
		load_penalty_from_save()

func set_level_name(level_name):
	LEVEL_NAME = level_name

func load_penalty_from_save():
	var penalty = Save.get_level_penalty(CHAPTER, LEVEL_NAME)
	if penalty > 0:
		var penalty_int = int(ceil(penalty))
		BUTTON.disabled = true
		BUTTON.text = "🔒   " + "%02d:%02d" % [penalty_int / 60, penalty_int % 60]
	else:
		BUTTON.disabled = false
		BUTTON.text = SUBMIT_TEXT

func disable():
	BUTTON.disabled = true
	
func make_hidden():
	BUTTON.visible = false

func return_normal():
	BUTTON.modulate = Color.WHITE
	background_width = 0
	BACKGROUND.custom_minimum_size.x = background_width
	is_held_down = false
	
func button_down():
	BUTTON.modulate = Color.WEB_GRAY
	is_held_down = true
