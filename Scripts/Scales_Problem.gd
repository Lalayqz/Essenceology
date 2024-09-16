extends Node
 
signal new_aspect_answered
@onready var PROBLEM_NAME = self.name
@onready var LANGUAGE = Config.get_language()
@onready var INPUT = $Input/Input
var ASPECTS = []
@export var ASPECT_GOAL: int
@export var MAX_INPUT_LENGTH_EN: int
@export var MAX_INPUT_LENGTH_ZH_CN: int

# Called when the node enters the scene tree for the first time.
func _ready():
	for aspect in $Aspects/Good_Aspects/Good_Aspects.get_children():
		ASPECTS.append(aspect)
	for aspect in $Aspects/Bad_Aspects/Bad_Aspects.get_children():
		ASPECTS.append(aspect)
		
func _input(event):
	if event is InputEventKey and event.is_pressed():
		# Character input
		if event.unicode != 0:
			match LANGUAGE:
				"en":
					if INPUT.text.length() < MAX_INPUT_LENGTH_EN and event.keycode >= KEY_A and event.keycode <= KEY_Z:
						if INPUT.text.length() == 0:
							INPUT.text += event.as_text()
						else:
							INPUT.text += event.as_text().to_lower()
						check_match_aspects()
				"zh_CN":
					if INPUT.text.length() < MAX_INPUT_LENGTH_ZH_CN and event.unicode >= 0x4E00 and event.unicode <= 0x9FFF:
						INPUT.text += char(event.unicode)
						check_match_aspects()
		
		# Backspace
		elif event.keycode == KEY_BACKSPACE:
			if Input.is_key_pressed(KEY_CTRL):
				INPUT.text = ""
			else:
				INPUT.text = INPUT.text.erase(INPUT.text.length() - 1, 1)
			
		# Delete
		elif event.keycode == KEY_DELETE:
			INPUT.text = ""	

func check_match_aspects():
	for aspect in ASPECTS:
		if aspect.check_match(INPUT.text, LANGUAGE):
			aspect.solve()
			new_aspect_answered.emit()

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
