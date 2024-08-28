extends Node

signal answer_set_to_should(option_name)
@onready var OPTION_NAME = self.name
@onready var SHOULD_BUTTON = $Button/Button
@export var REFERENCE_ANSWER: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	SHOULD_BUTTON.answer_set_to_should.connect(emit_signal_answer_set_to_should)
	set_answer(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func is_selected():
	return SHOULD_BUTTON.should
	
func is_correct():
	var test = REFERENCE_ANSWER
	var bo = SHOULD_BUTTON.should == REFERENCE_ANSWER
	return SHOULD_BUTTON.should == REFERENCE_ANSWER

func disable():
	SHOULD_BUTTON.disabled = true
	
func save_answer(answers):
	answers[OPTION_NAME] = SHOULD_BUTTON.get_answer()
	
func load_answer(answers):
	if OPTION_NAME in answers:
		SHOULD_BUTTON.switch_to(answers[OPTION_NAME])
		
func set_answer(answer):
	SHOULD_BUTTON.switch_to(answer)

func connect_signal_update_submit_button_visibility(update_submit_button_visibility):
	SHOULD_BUTTON.answer_changed.connect(update_submit_button_visibility) 
	
func emit_signal_answer_set_to_should():
	answer_set_to_should.emit(OPTION_NAME)
	 
