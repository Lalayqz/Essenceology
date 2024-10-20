class_name Level extends Node2D

#const PENALTIES = [1, 3, 6, 10]
const PENALTIES = [0.1]
var problems = []
var wrong_answer_sound = preload("res://resources/sounds/wrong_answer.mp3")
var text_font = preload("res://resources/fonts/SourceHanSansSC-Normal.otf")
var is_solved = false
@onready var chapter = Global_Variables.current_chapter
@onready var level_name = self.name
@onready var level_structure = get_node("LevelStructure")
@onready var title = level_structure.get_node("Ui/Title")
@onready var solved_label = level_structure.get_node("Ui/SolvedLabel/Label")
# If the locale codename makes the "Problems" center container's width exceed the screen width,
# then 1) Type in screen width into the center container's size.x;
# 2) Type in the locale codename and now the center container's size.x shows a value that's larger than the screen width;
# 3) DO NOT EDIT THE CENTER CONTAINER'S SIZE AFTER STEP 2 or its width will always be that value even after the gam starts and the locale with smaller width gets loaded.


func _ready():
	# connect children's signals
	var back_button =  level_structure.get_node("Ui/BackButton")
	back_button.pressed.connect(exit_level)
	
	# set level structure appearance according to current chapter
	level_structure.get_node("Background").color = Global_Variables.current_chapter_background_color
	level_structure.get_node("Ui/Title").set("theme_override_colors/font_shadow_color", Global_Variables.current_chapter_color)
	
	title.text = level_name


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		exit_level()


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		exit_level()


func solve_level(also_save):
	is_solved = true
	
	solved_label.set("theme_override_colors/font_shadow_color", Global_Variables.current_chapter_color)
	solved_label.visible = true
	if also_save:
		Save.save_level_solved(chapter, level_name)
		if Global_Variables.is_finale(chapter, level_name):
			Save.save_chapter_solved(chapter)
		save_answers()


func strip_bbcode(string):
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	return regex.sub(string, "", true)


func is_all_answered():
	var all_answered = true
	for problem in problems:
		if not problem.is_answered():
			all_answered = false
			break
	return all_answered


# Just check. Doesn't trigger anything.
func is_all_correct():
	for problem in problems:
		if not problem.is_correct():
			return false
	return true


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
