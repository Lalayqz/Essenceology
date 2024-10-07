class_name ScalesLevel extends LevelWithProgressBar

const MAX_PROBLEM_TEXT_WIDTH = 1000
const INPUT_CORRECT_COLOR = Color.GREEN
const INPUT_WRONG_COLOR = Color.RED
@export var max_input_length_en: int
@export var max_input_length_zh_cn: int
@onready var input = $Body/Body/Input/Input/Input
@onready var language = Config.get_language()


func _ready():
	super()
	
	update_word_warp()


func _input(event):
	if event is InputEventKey and event.is_pressed():
		var is_max_length
		var inputed = false
		# Character input
		if event.unicode != 0:
			match language:
				"en":
					is_max_length = input.text.length() >= max_input_length_en
					if not is_max_length and event.keycode >= KEY_A and event.keycode <= KEY_Z:
						if input.text.length() == 0:
							input.text += OS.get_keycode_string(event.keycode)
						else:
							input.text += OS.get_keycode_string(event.keycode).to_lower()
						inputed = true
						is_max_length = input.text.length() >= max_input_length_en
				"zh_CN":
					is_max_length = input.text.length() >= max_input_length_zh_cn
					if not is_max_length and event.unicode >= 0x4E00 and event.unicode <= 0x9FFF:
						input.text += char(event.unicode)
						inputed = true
						is_max_length = input.text.length() >= max_input_length_zh_cn
		
		# Backspace
		elif event.keycode == KEY_BACKSPACE:
			if Input.is_key_pressed(KEY_CTRL):
				input.text = ""
			else:
				input.text = input.text.erase(input.text.length() - 1, 1)
			inputed = true
			
		# Delete
		elif event.keycode == KEY_DELETE:
			input.text = ""
			inputed = true
			
		if inputed:
			check_match_aspects(is_max_length)


func check_match_aspects(is_max_length):
	var matched = false
	
	for problem in problems:
		if problem.check_match_aspects(input.text, language):
			matched = true # Don't break now! Other aspects still need to be checked.
	
	if matched:
		input.modulate = INPUT_CORRECT_COLOR
		update_progress_bar(true)
	else:
		if is_max_length:
			input.modulate = INPUT_WRONG_COLOR
		else:
			input.modulate = Color.WHITE


func update_word_warp():
	for problem in problems:
		var problem_text = problem.get_node("Text/Text")

		# bbcode like [hint=...] is not included when calculating text width
		var string = strip_bbcode(TranslationServer.translate(problem_text.text))
		if text_font.get_string_size(string, HORIZONTAL_ALIGNMENT_LEFT, -1, problem_text.get_theme_font_size("normal_font_size")).x > MAX_PROBLEM_TEXT_WIDTH:
			# set text autowarp if its width exceeds MAX_TEXT_WIDTH
			problem_text.set_autowrap_mode(TextServer.AUTOWRAP_WORD)
			problem_text.set_custom_minimum_size(Vector2(MAX_PROBLEM_TEXT_WIDTH, 0))
		else:
			problem_text.set_autowrap_mode(TextServer.AUTOWRAP_OFF)
			problem_text.set_custom_minimum_size(Vector2(0, 0))
