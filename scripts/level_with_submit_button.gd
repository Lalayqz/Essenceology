class_name LevelWithSubmitButton extends Level

@onready var submit_button = level_structure.get_node("Ui/SubmitButton/SubmitButton")
@onready var problems_container = $Problems/Problems


func _ready():
	super()
	
	var problems_and_lines = get_node("Problems/Problems").get_children()
	for problem_or_line in problems_and_lines:
		if problem_or_line is MarginContainer:
			problems.append(problem_or_line)
	load_answers()
	
	submit_button.submit.connect(submit_answers)
	submit_button.set_level_name(level_name)
	for problem in problems:
		problem.connect_signal_update_submit_button_visibility(update_submit_button_visibility)
	
	# set solved
	# It's possible that I update the problems and the inputs for an already solved level is not longer correct.
	# If this happens, just make the content in level appear as unsolved. Don't remove this level from solved levels in save.
	if Save.get_level_solved(chapter, level_name) and is_all_correct():
		solve_level(false)
	
	update_submit_button_visibility()
	submit_button.load_penalty_from_save()


func update_submit_button_visibility():
	var v = false
	if not is_solved:
		v = is_all_answered()
	submit_button.visible = v


func update_submit_button_penalty():
	var penalty = Save.get_level_penalty(chapter, level_name)
	submit_button.set_penalty(penalty)

# Check and trigger corresponding things.
func submit_answers():
	if is_all_correct():
		# correct answer!
		solve_level(true)
		
		# set light color
		Lights.color_flash(chapter, "CORRECT_ANSWER")
	else:
		# wrong answer!
		submit_button.disable()
		var fail = Save.get_level_fail(chapter, level_name)
		var penalty = PENALTIES[fail] * 60 if fail < len(PENALTIES) else PENALTIES[-1] * 60
		Save.save_level_fail(chapter, level_name, fail + 1)
		Save.save_level_penalty(chapter, level_name, penalty)
		
		# play audio
		var audio_player = AudioStreamPlayer.new()
		get_tree().root.add_child(audio_player)
		audio_player.stream = wrong_answer_sound
		audio_player.play()
		audio_player.finished.connect(on_sound_finished.bind(audio_player))
		# set light color
		Lights.color_flash(chapter, "WRONG_ANSWER")


func on_sound_finished(audio_player):
	audio_player.queue_free()


func solve_level(also_save):
	super(also_save)
	
	for problem in problems:
		problem.disable()
	submit_button.make_hidden()
