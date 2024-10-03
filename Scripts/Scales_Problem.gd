extends Node
 
signal new_aspect_answered
@onready var PROBLEM_NAME = self.name
@onready var LANGUAGE = Config.get_language()
@onready var INPUT = $Input/Input
@export var ASPECT_GOAL: int
@export var MAX_INPUT_LENGTH_EN: int
@export var MAX_INPUT_LENGTH_ZH_CN: int
var ASPECTS = []
var INPUT_CORRECT_COLOR = Color.GREEN
var INPUT_WRONG_COLOR = Color.RED

# Called when the node enters the scene tree for the first time.
func _ready():
	for aspect in $Aspects/Good_Aspects/Good_Aspects.get_children():
		ASPECTS.append(aspect)
	for aspect in $Aspects/Bad_Aspects/Bad_Aspects.get_children():
		ASPECTS.append(aspect)
		
func _input(event):
	if event is InputEventKey and event.is_pressed():
		var is_max_length
		var inputed = false
		# Character input
		if event.unicode != 0:
			match LANGUAGE:
				"en":
					is_max_length = INPUT.text.length() >= MAX_INPUT_LENGTH_EN
					if not is_max_length and event.keycode >= KEY_A and event.keycode <= KEY_Z:
						if INPUT.text.length() == 0:
							INPUT.text += OS.get_keycode_string(event.keycode)
						else:
							INPUT.text += OS.get_keycode_string(event.keycode).to_lower()
						inputed = true
						is_max_length = INPUT.text.length() == MAX_INPUT_LENGTH_EN
				"zh_CN":
					is_max_length = INPUT.text.length() == MAX_INPUT_LENGTH_ZH_CN
					if not is_max_length and event.unicode >= 0x4E00 and event.unicode <= 0x9FFF:
						INPUT.text += char(event.unicode)
						inputed = true
						is_max_length = INPUT.text.length() == MAX_INPUT_LENGTH_EN
		
		# Backspace
		elif event.keycode == KEY_BACKSPACE:
			if Input.is_key_pressed(KEY_CTRL):
				INPUT.text = ""
			else:
				INPUT.text = INPUT.text.erase(INPUT.text.length() - 1, 1)
			inputed = true
			
		# Delete
		elif event.keycode == KEY_DELETE:
			INPUT.text = ""
			inputed = true
			
		if inputed:
			check_match_aspects(is_max_length)

func check_match_aspects(is_max_length):
	var matched = false
	
	for aspect in ASPECTS:
		if aspect.check_match(INPUT.text, LANGUAGE):
			matched = true
			aspect.solve()
			
	if matched:
		new_aspect_answered.emit()
		INPUT.modulate = INPUT_CORRECT_COLOR
	else:
		if is_max_length:
			INPUT.modulate = INPUT_WRONG_COLOR
		else:
			INPUT.modulate = Color.WHITE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func save_answer(chapter, level_name):
	var answers = []
	for aspect in ASPECTS:
		aspect.save_answer(answers)
	Save.save_problem_answer(chapter, level_name, PROBLEM_NAME, answers)
	
func load_answer(chapter, level_name):
	var answers = Save.get_problem_answer(chapter, level_name, PROBLEM_NAME)
	if answers != null:
		for aspect in ASPECTS:
			aspect.load_answer(answers)
