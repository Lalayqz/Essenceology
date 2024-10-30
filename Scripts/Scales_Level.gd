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
		var input_key = OS.get_keycode_string(event.keycode)
		var inputed = false
		
		# Character input
		if event.unicode != 0:
			match language:
				"en":
					if event.keycode >= KEY_A and event.keycode <= KEY_Z: # When Chinese is inputed, input_key will be 'Unknown'
						inputed = append_to_input_box(input_key)
				"zh_CN":
					inputed = append_to_input_box(char(event.unicode))
		
		# Backspace
		elif event.keycode == KEY_BACKSPACE:
			if Input.is_key_pressed(KEY_CTRL):
				input.text = ""
			else:
				if len(input.text) > 0:
					input.text = input.text.erase(input.text.length() - 1, 1)
			inputed = true
			
		# Delete
		elif event.keycode == KEY_DELETE:
			input.text = ""
			inputed = true
		
		# Copy & paste
		elif Input.is_key_pressed(KEY_CTRL):
			if input_key.to_lower() == 'c':
				DisplayServer.clipboard_set(input.text)
			if input_key.to_lower() == 'v':
				inputed = append_to_input_box(DisplayServer.clipboard_get())
		
		if inputed:
			call_deferred('check_match_aspects')


# Returns false if nothing is appended.
func append_to_input_box(string):
	if input_is_max_length():
		return false
	
	match language:
		"en":
			for character in string:
				var lower_character = character.to_lower()
				if lower_character >= 'a' and character <= 'z':
					input.text += lower_character
			input.text = input.text.substr(0, max_input_length_en)
			input.text[0] = input.text[0].to_upper()
		"zh_CN":
			for character in string:
				if character.unicode_at(0) >= 0x4E00 and character.unicode_at(0) <= 0x9FFF:
					input.text += character
			input.text = input.text.substr(0, max_input_length_zh_cn)
	return true


func character_is_in_language(character):
	match language:
		"en":
			return 
		"zh_CN":
			return character >= 0x4E00 and character <= 0x9FFF


func check_match_aspects():
	var matched = false
	
	for problem in problems:
		if problem.check_match_aspects(input.text, language):
			matched = true # Don't break now! Other aspects still need to be checked.
	
	if matched:
		input.modulate = INPUT_CORRECT_COLOR
		update_progress_bar(true)
	else:
		if input_is_max_length():
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
			problem_text.set_autowrap_mode(TextServer.AUTOWRAP_WORD_SMART)
			problem_text.set_custom_minimum_size(Vector2(MAX_PROBLEM_TEXT_WIDTH, 0))
		else:
			problem_text.set_autowrap_mode(TextServer.AUTOWRAP_OFF)
			problem_text.set_custom_minimum_size(Vector2(0, 0))


func input_is_max_length():
	match language:
		"en":
			return input.text.length() >= max_input_length_en
		"zh_CN":
			return input.text.length() >= max_input_length_zh_cn
