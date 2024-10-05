extends Node

@export var allow_multiple_answers: bool
@onready var problem_name = self.name
@onready var options = get_node("Problem/Options").get_children()


func _ready():
	if not allow_multiple_answers:
		for option in options:
			option.answer_set_to_should.connect(remove_other_answers)


func is_answered():
	for option in options:
		if option.is_selected():
			return true
	return false


func is_correct():
	for option in options:
		if not option.is_correct():
			return false
	return true


func disable():
	for option in options:
		option.disable()


func save_answer(chapter, level_name):
	var answers = {}
	for option in options:
		option.save_answer(answers)
	Save.save_problem_answer(chapter, level_name, problem_name, answers)


func load_answer(chapter, level_name):
	var answers = Save.get_problem_answer(chapter, level_name, problem_name)
	if answers != null:
		for option in options:
			option.load_answer(answers)


func remove_other_answers(option_name):
	for option in options:
		if option.option_name != option_name:
			option.set_answer(false)


# connect the signal to update_submit_button_visibility() in level
func connect_signal_update_submit_button_visibility(update_submit_button_visibility):
	for option in options:
		option.connect_signal_update_submit_button_visibility(update_submit_button_visibility)
