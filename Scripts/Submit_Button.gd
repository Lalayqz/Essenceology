class_name SubmitButton extends NeatButton

signal submit
const SUBMIT_TEXT = "SUBMIT_HOLD"
const HOLD_TIME = 1
var level_name
var background_width = 0
var is_held_down = false
@onready var chapter = Global_Variables.current_chapter
@onready var background = get_node("Background")
@onready var width = size.x
@onready var background_progress_speed = float(width) / HOLD_TIME


func _process(delta):
	if is_held_down:
		background_width += delta * background_progress_speed
		if background_width >= width:
			submit.emit()
			return_normal()
		background.custom_minimum_size.x = background_width
	if disabled:
		load_penalty_from_save()


func set_level_name(n):
	level_name = n


func load_penalty_from_save():
	var penalty = Save.get_level_penalty(chapter, level_name)
	if penalty > 0:
		var penalty_int = int(ceil(penalty))
		disabled = true
		self.text = "🔒   " + "%02d:%02d" % [penalty_int / 60, penalty_int % 60]
	else:
		disabled = false
		self.text = SUBMIT_TEXT


func disable():
	disabled = true


func make_hidden():
	self.visible = false


func released():
	return_normal()
	super()


func return_normal():
	super()
	background_width = 0
	background.custom_minimum_size.x = background_width
	is_held_down = false


func button_down():
	super()
	is_held_down = true
