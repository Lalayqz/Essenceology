extends Node

signal answer_set_to_should(option_name)
@export var reference_answer: bool
@onready var option_name = self.name
@onready var should_button = $Button/Button


func _ready():
	should_button.answer_set_to_should.connect(emit_signal_answer_set_to_should)
	set_answer(false)


func is_selected():
	return should_button.should


func is_correct():
	return should_button.should == reference_answer


func disable():
	should_button.disabled = true


func save_answer(answers):
	answers[option_name] = should_button.get_answer()


func load_answer(answers):
	if option_name in answers:
		should_button.switch_to(answers[option_name])


func set_answer(answer):
	should_button.switch_to(answer)


func connect_signal_update_submit_button_visibility(update_submit_button_visibility):
	should_button.answer_changed.connect(update_submit_button_visibility) 


func emit_signal_answer_set_to_should():
	answer_set_to_should.emit(option_name)
