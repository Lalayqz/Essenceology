extends Node

@onready var BUTTON = get_node("Problem/Button/Button")
@onready var PROBLEM_NAME = self.name

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func is_answered():
	return BUTTON.possibility != null
	
func is_correct():
	return BUTTON.possibility == BUTTON.REFERENCE_ANSWER

func disable():
	BUTTON.disabled = true
	
func save_answer(chapter, level_name):
	Save.save_problem_answer(chapter, level_name, PROBLEM_NAME, BUTTON.possibility)
	
func load_answer(chapter, level_name):
	var answer = Save.get_problem_answer(chapter, level_name, PROBLEM_NAME)
	if answer != null:
		BUTTON.switch_to(answer)
	
# connect the signal to update_submit_button_visibility() in level
func connect_signal_update_submit_button_visibility(update_submit_button_visibility):
	BUTTON.answer_changed.connect(update_submit_button_visibility)
