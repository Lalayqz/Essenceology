extends Node

@onready var OPTIONS = get_node("Problem/Options").get_children()
@onready var PROBLEM_NAME = self.name
@export var ALLOW_MULTIPLE_ANSWERS: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	if not ALLOW_MULTIPLE_ANSWERS:
		for option in OPTIONS:
			option.answer_set_to_should.connect(remove_other_answers)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func is_answered():
	for option in OPTIONS:
		if option.is_selected():
			return true
	return false
	
func is_correct():
	for option in OPTIONS:
		if not option.is_correct():
			return false
	return true

func disable():
	for option in OPTIONS:
		option.disable()
	
func save_answer(chapter, level_name):
	var answers = {}
	for option in OPTIONS:
		option.save_answer(answers)
	Save.save_problem_answer(chapter, level_name, PROBLEM_NAME, answers)
	
func load_answer(chapter, level_name):
	var answers = Save.get_problem_answer(chapter, level_name, PROBLEM_NAME)
	if answers != null:
		for option in OPTIONS:
			option.load_answer(answers)
			
func remove_other_answers(option_name):
	for option in OPTIONS:
		if option.OPTION_NAME != option_name:
			option.set_answer(false)
	
# connect the signal to update_submit_button_visibility() in level
func connect_signal_update_submit_button_visibility(update_submit_button_visibility):
	for option in OPTIONS:
		option.connect_signal_update_submit_button_visibility(update_submit_button_visibility)
