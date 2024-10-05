extends Node

@onready var button = get_node("Problem/Button/Button")
@onready var problem_name = self.name


func is_answered():
	return button.possibility != null


func is_correct():
	return button.possibility == button.reference_answer


func disable():
	button.disabled = true


func save_answer(chapter, level_name):
	Save.save_problem_answer(chapter, level_name, problem_name, button.possibility)


func load_answer(chapter, level_name):
	var answer = Save.get_problem_answer(chapter, level_name, problem_name)
	if answer != null:
		button.switch_to(answer)


# connect the signal to update_submit_button_visibility() in level
func connect_signal_update_submit_button_visibility(update_submit_button_visibility):
	button.answer_changed.connect(update_submit_button_visibility)
