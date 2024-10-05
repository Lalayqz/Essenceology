extends Node
 
signal new_aspect_answered
const INPUT_CORRECT_COLOR = Color.GREEN
const INPUT_WRONG_COLOR = Color.RED
@export var points_goal: int
@export var max_input_length_en: int
@export var max_input_length_zh_cn: int
var aspects = []
@onready var problem_name = self.name
@onready var language = Config.get_language()
@onready var input = $Input/Input


func _ready():
	for aspect in $Aspects/GoodAspects/GoodAspects.get_children():
		aspects.append(aspect)
	for aspect in $Aspects/BadAspects/BadAspects.get_children():
		aspects.append(aspect)


func _input(event):
	if event is InputEventKey and event.is_pressed():
		var is_max_length
		var inputed = false
		# Character input
		if event.unicode != 0:
			match language:
				"en":
					is_max_length = input.text.length() >= max_input_length_en
					if not is_max_length and event.keycode >= KEY_A and event.keycode <= KEY_Z:
						if input.text.length() == 0:
							input.text += OS.get_keycode_string(event.keycode)
						else:
							input.text += OS.get_keycode_string(event.keycode).to_lower()
						inputed = true
						is_max_length = input.text.length() >= max_input_length_en
				"zh_CN":
					is_max_length = input.text.length() >= max_input_length_zh_cn
					if not is_max_length and event.unicode >= 0x4E00 and event.unicode <= 0x9FFF:
						input.text += char(event.unicode)
						inputed = true
						is_max_length = input.text.length() >= max_input_length_zh_cn
		
		# Backspace
		elif event.keycode == KEY_BACKSPACE:
			if Input.is_key_pressed(KEY_CTRL):
				input.text = ""
			else:
				input.text = input.text.erase(input.text.length() - 1, 1)
			inputed = true
			
		# Delete
		elif event.keycode == KEY_DELETE:
			input.text = ""
			inputed = true
			
		if inputed:
			check_match_aspects(is_max_length)


func check_match_aspects(is_max_length):
	var matched = false
	
	for aspect in aspects:
		if aspect.check_match(input.text, language):
			matched = true
			aspect.solve()
			
	if matched:
		new_aspect_answered.emit()
		input.modulate = INPUT_CORRECT_COLOR
	else:
		if is_max_length:
			input.modulate = INPUT_WRONG_COLOR
		else:
			input.modulate = Color.WHITE


func save_answer(chapter, level_name):
	var answers = []
	for aspect in aspects:
		aspect.save_answer(answers)
	Save.save_problem_answer(chapter, level_name, problem_name, answers)


func load_answer(chapter, level_name):
	var answers = Save.get_problem_answer(chapter, level_name, problem_name)
	if answers != null:
		for aspect in aspects:
			aspect.load_answer(answers)
