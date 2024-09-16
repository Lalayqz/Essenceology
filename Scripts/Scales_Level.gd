class_name Scales_Level extends Level

var MAX_PROBLEM_TEXT_WIDTH = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	# connect children's signals
	var back_button =  LEVEL_STRUCTURE.get_node("UI/Back_Button")
	back_button.pressed.connect(exit_level)

	PROBLEMS = []
	PROBLEMS.append($Problem.get_child(0))
	for problem in PROBLEMS:
		problem.new_aspect_answered.connect(save_answers)
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
		
	update_word_warp()

func update_word_warp():
	for problem in PROBLEMS:
		var problem_text = problem.get_node("Text/Text")

		# bbcode like [hint=...] is not included when calculating text width
		var string = strip_bbcode(TranslationServer.translate(problem_text.text))
		if TEXT_FONT.get_string_size(string, 0, -1, problem_text.get_theme_font_size("normal_font_size")).x > MAX_PROBLEM_TEXT_WIDTH:
			# set text autowarp if its width exceeds MAX_TEXT_WIDTH
			problem_text.set_autowrap_mode(TextServer.AUTOWRAP_WORD)
			problem_text.set_custom_minimum_size(Vector2(MAX_PROBLEM_TEXT_WIDTH, 0))
		else:
			problem_text.set_autowrap_mode(TextServer.AUTOWRAP_OFF)
			problem_text.set_custom_minimum_size(Vector2(0, 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
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
	for problem in PROBLEMS:
		problem.load_answer(CHAPTER, LEVEL_NAME)
	
func save_answers():
	for problem in PROBLEMS:
		problem.save_answer(CHAPTER, LEVEL_NAME)
	Save.save_game()
