class_name Level extends Node2D

@onready var CHAPTER = Global_Variables.current_chapter
@onready var LEVEL_NAME = self.name
@onready var LEVEL_STRUCTURE = get_node("Level_Structure")
@onready var TITLE = LEVEL_STRUCTURE.get_node("UI/Title")
@onready var SUBMIT_BUTTON = LEVEL_STRUCTURE.get_node("UI/Submit_Button")
@onready var SOLVED_LABEL = LEVEL_STRUCTURE.get_node("UI/Solved_Label/Label/Label")
@onready var AUDIO_PLAYER = LEVEL_STRUCTURE.get_node("Audio_Player")
@onready var PROBLEMS_CONTAINER = get_node("Problems/Problems")
@onready var PROBLEMS = PROBLEMS_CONTAINER.get_children()
var WRONG_ANSWER_SOUND = preload("res://Resources/Sounds/Wrong_Answer.mp3")
var TEXT_FONT = preload("res://Resources/SourceHanSansSC-Normal.otf")
var TEXT_FONT_SIZE = 33
var PENALTIES = [1, 3, 6, 10]

# Called when the node enters the scene tree for the first time.
func _ready():
	# connect children's signals
	SUBMIT_BUTTON.submit.connect(submit_answers)
	SUBMIT_BUTTON.set_level_name(LEVEL_NAME)
	var back_button =  LEVEL_STRUCTURE.get_node("UI/Back_Button")
	back_button.pressed.connect(exit_level)
	for problem in PROBLEMS:
		problem.connect_signal_update_submit_button_visibility(update_submit_button_visibility)
	load_answers()
	
	# set level structure appearance according to current chapter
	LEVEL_STRUCTURE.get_node("Background").color = Global_Variables.current_chapter_background_color
	LEVEL_STRUCTURE.get_node("UI/Title").set("theme_override_colors/font_shadow_color", Global_Variables.current_chapter_color)
	
	TITLE.text = LEVEL_NAME
	
	# set solved
	# It's possible that I update the problems and the inputs for an already solved level is not longer correct.
	# If this happens, just make the content in level appears as unsolved. Don't remove this level from solved levels in save.
	if Save.get_level_solved(CHAPTER, LEVEL_NAME) and is_all_correct():
		solve_level()
	# set submit button
	update_submit_button_visibility()
	SUBMIT_BUTTON.load_penalty_from_save()

func strip_bbcode(string):
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	return regex.sub(string, "", true)
						
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		exit_level()

func _notification(notification):
	if notification == NOTIFICATION_WM_CLOSE_REQUEST:
		exit_level()

func is_all_answered():
	var all_answered = true
	for problem in PROBLEMS:
		if not problem.is_answered():
			all_answered = false
			break
	return all_answered
	
func update_submit_button_visibility():
	SUBMIT_BUTTON.visible = is_all_answered()

# Just check. Doesn't trigger anything.
func is_all_correct():
	for problem in PROBLEMS:
		if not problem.is_correct():
			return false
	return true

func update_submit_button_penalty():
	var penalty = Save.get_level_penalty(CHAPTER, LEVEL_NAME)
	SUBMIT_BUTTON.set_penalty(penalty)

# Check and trigger corresponding things.
func submit_answers():
	if is_all_correct():
		# correct answer!
		solve_level()
	else:
		# wrong answer!
		SUBMIT_BUTTON.disable()
		var fail = Save.get_level_fail(CHAPTER, LEVEL_NAME)
		var penalty = PENALTIES[fail] * 60 if fail < len(PENALTIES) else PENALTIES[-1] * 60
		Save.save_level_fail(CHAPTER, LEVEL_NAME, fail + 1)
		Save.save_level_penalty(CHAPTER, LEVEL_NAME, penalty)
		AUDIO_PLAYER.stream = WRONG_ANSWER_SOUND
		AUDIO_PLAYER.play()
	
func solve_level():
	Save.save_level_solved(CHAPTER, LEVEL_NAME)
	if Global_Variables.is_finale(CHAPTER, LEVEL_NAME):
		Save.save_chapter_solved(CHAPTER)
	save_answers()
	for problem in PROBLEMS:
		problem.disable()
	SUBMIT_BUTTON.make_hidden()
	SOLVED_LABEL.set("theme_override_colors/font_shadow_color", Global_Variables.current_chapter_color)
	SOLVED_LABEL.visible = true
	
func load_answers():
	for problem in PROBLEMS:
		problem.load_answer(CHAPTER, LEVEL_NAME)
	
func save_answers():
	for problem in PROBLEMS:
		problem.save_answer(CHAPTER, LEVEL_NAME)
	Save.save_game()

func exit_level():
	save_answers()
	get_tree().change_scene_to_file("res://Scenes/Menus/MainMenu.tscn")
