extends Node2D

signal submit
const SUBMIT_TEXT = "SUBMIT_HOLD"
const HOLD_TIME = 1
var level_name
var background_width = 0
var is_held_down = false
@onready var chapter = Global_Variables.current_chapter
@onready var background = get_node("Background")
@onready var button = get_node("Button/Button")
@onready var width = button.size.x
@onready var background_progress_speed = float(width) / HOLD_TIME


func _process(delta):
	if is_held_down:
		background_width += delta * background_progress_speed
		if background_width >= width:
			submit.emit()
			return_normal()
		background.custom_minimum_size.x = background_width
	if button.disabled:
		load_penalty_from_save()


func set_level_name(n):
	level_name = n


func load_penalty_from_save():
	var penalty = Save.get_level_penalty(chapter, level_name)
	if penalty > 0:
		var penalty_int = int(ceil(penalty))
		button.disabled = true
		button.text = "🔒   " + "%02d:%02d" % [penalty_int / 60, penalty_int % 60]
	else:
		button.disabled = false
		button.text = SUBMIT_TEXT


func disable():
	button.disabled = true


func make_hidden():
	button.visible = false


func return_normal():
	button.modulate = Color.WHITE
	background_width = 0
	background.custom_minimum_size.x = background_width
	is_held_down = false


func button_down():
	button.modulate = Color.WEB_GRAY
	is_held_down = true
