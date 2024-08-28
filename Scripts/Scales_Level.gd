class_name Scales_Level extends Node2D

@onready var CHAPTER = Global_Variables.current_chapter
@onready var LEVEL_NAME = self.name
@onready var LEVEL_STRUCTURE = get_node("Level_Structure")
@onready var TITLE = LEVEL_STRUCTURE.get_node("UI/Title")
@onready var SOLVED_LABEL = LEVEL_STRUCTURE.get_node("UI/Solved_Label/Label/Label")
@onready var AUDIO_PLAYER = LEVEL_STRUCTURE.get_node("Audio_Player")
@onready var PROBLEMS_CONTAINER = get_node("Problems/Problems")
var WRONG_ANSWER_SOUND = preload("res://Resources/Sounds/Wrong_Answer.mp3")
var TEXT_FONT = preload("res://Resources/SourceHanSansSC-Normal.otf")
var PENALTIES = [1, 3, 6, 10]
# If the locale codename makes the "Problems" center container's width exceed the screen width,
# then 1) Type in screen width into the center container's size.x;
# 2) Type in the locale codename and now the center container's size.x shows a value that's larger than the screen width;
# 3) DO NOT EDIT THE CENTER CONTAINER'S SIZE AFTER STEP 2 or its width will always be that value even after the gam starts and the locale with smaller width gets loaded.

# Called when the node enters the scene tree for the first time.
func _ready():
	# connect children's signals
	var back_button =  LEVEL_STRUCTURE.get_node("UI/Back_Button")
	back_button.pressed.connect(exit_level)

	LEVEL_STRUCTURE.get_node("UI/Submit_Button").visible = false
	load_answers()
	
	# set level structure appearance according to current chapter
	LEVEL_STRUCTURE.get_node("Background").color = Global_Variables.current_chapter_background_color
	LEVEL_STRUCTURE.get_node("UI/Title").set("theme_override_colors/font_shadow_color", Global_Variables.current_chapter_color)
	
	TITLE.text = LEVEL_NAME
	
	# set solved
	# It's possible that I update the problems and the inputs for an already solved level is not longer correct.
	# If this happens, just make the content in level appear as unsolved. Don't remove this level from solved levels in save.
	if Save.get_level_solved(CHAPTER, LEVEL_NAME):
		solve_level()

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
	
func solve_level():
	Save.save_level_solved(CHAPTER, LEVEL_NAME)
	if Global_Variables.is_finale(CHAPTER, LEVEL_NAME):
		Save.save_chapter_solved(CHAPTER)
	save_answers()
	#for problem in PROBLEMS:
		#problem.disable()
	SOLVED_LABEL.set("theme_override_colors/font_shadow_color", Global_Variables.current_chapter_color)
	SOLVED_LABEL.visible = true
	
func load_answers():
	pass
	
func save_answers():
	pass
	Save.save_game()

func exit_level():
	save_answers()
	get_tree().change_scene_to_file("res://Scenes/Menus/MainMenu.tscn")
