class_name Level extends Node2D

#const PENALTIES = [1, 3, 6, 10]
const PENALTIES = [0.1]
var problems
var wrong_answer_sound = preload("res://resources/sounds/wrong_answer.mp3")
var text_font = preload("res://resources/fonts/SourceHanSansSC-Normal.otf")
@onready var chapter = Global_Variables.current_chapter
@onready var level_name = self.name
@onready var level_structure = get_node("LevelStructure")
@onready var title = level_structure.get_node("Ui/Title")
@onready var submit_button = level_structure.get_node("Ui/SubmitButton")
@onready var solved_label = level_structure.get_node("Ui/SolvedLabel/Label/Label")
@onready var audio_player = level_structure.get_node("AudioPlayer")
@onready var problems_container = get_node("Problems/Problems")
# If the locale codename makes the "Problems" center container's width exceed the screen width,
# then 1) Type in screen width into the center container's size.x;
# 2) Type in the locale codename and now the center container's size.x shows a value that's larger than the screen width;
# 3) DO NOT EDIT THE CENTER CONTAINER'S SIZE AFTER STEP 2 or its width will always be that value even after the gam starts and the locale with smaller width gets loaded.


func _ready():
	# connect children's signals
	submit_button.submit.connect(submit_answers)
	submit_button.set_level_name(level_name)
	var back_button =  level_structure.get_node("Ui/BackButton")
	back_button.pressed.connect(exit_level)
	
	problems = []
	var problems_and_lines = problems_container.get_children()
	for problem_or_line in problems_and_lines:
		if problem_or_line is MarginContainer:
			problems.append(problem_or_line)
	for problem in problems:
		problem.connect_signal_update_submit_button_visibility(update_submit_button_visibility)
	load_answers()
	
	# set level structure appearance according to current chapter
	level_structure.get_node("Background").color = Global_Variables.current_chapter_background_color
	level_structure.get_node("Ui/Title").set("theme_override_colors/font_shadow_color", Global_Variables.current_chapter_color)
	
	title.text = level_name
	
	# set solved
	# It's possible that I update the problems and the inputs for an already solved level is not longer correct.
	# If this happens, just make the content in level appear as unsolved. Don't remove this level from solved levels in save.
	if Save.get_level_solved(chapter, level_name) and is_all_correct():
		solve_level()
	# set submit button
	update_submit_button_visibility()
	submit_button.load_penalty_from_save()


func strip_bbcode(string):
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	return regex.sub(string, "", true)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		exit_level()


func _notification(notification):
	if notification == NOTIFICATION_WM_CLOSE_REQUEST:
		exit_level()


func is_all_answered():
	var all_answered = true
	for problem in problems:
		if not problem.is_answered():
			all_answered = false
			break
	return all_answered


func update_submit_button_visibility():
	submit_button.visible = is_all_answered()


# Just check. Doesn't trigger anything.
func is_all_correct():
	for problem in problems:
		if not problem.is_correct():
			return false
	return true


func update_submit_button_penalty():
	var penalty = Save.get_level_penalty(chapter, level_name)
	submit_button.set_penalty(penalty)


# Check and trigger corresponding things.
func submit_answers():
	if is_all_correct():
		# correct answer!
		solve_level()
		
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
		audio_player.stream = wrong_answer_sound
		audio_player.play()
		# set light color
		Lights.color_flash(chapter, "WRONG_ANSWER")


func solve_level():
	Save.save_level_solved(chapter, level_name)
	if Global_Variables.is_finale(chapter, level_name):
		Save.save_chapter_solved(chapter)
	save_answers()
	for problem in problems:
		problem.disable()
	submit_button.make_hidden()
	solved_label.set("theme_override_colors/font_shadow_color", Global_Variables.current_chapter_color)
	solved_label.visible = true


func load_answers():
	for problem in problems:
		problem.load_answer(chapter, level_name)


func save_answers():
	for problem in problems:
		problem.save_answer(chapter, level_name)
	Save.save_game()


func exit_level():
	save_answers()
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
