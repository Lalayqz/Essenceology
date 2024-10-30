extends LevelWithSubmitButton

const MAX_PROBLEM_TEXT_WIDTH = 1000
const MAX_OPTION_TEXT_WIDTH = 550
const MAX_TEXT_HEIGHT = 540
var extra_small_text_style = preload("res://resources/styles/problem_text_extra_small.tres")
var texts = []


func _ready():
	super()
	
	update_word_warp()
	call_deferred("check_and_shrink_font")


func update_word_warp():
	var problem_texts = []
	var option_texts = []
	
	for problem in problems:
		var problem_text = problem.get_node("Problem/Text/Text/Text")
		var options = problem.get_node("Problem/Options").get_children()
		problem_texts.append(problem_text)
		texts.append(problem_text)
		for option in options:
			var option_text = option.get_node("Text/Text/Text")
			option_texts.append(option_text)
			texts.append(option_text)
	
	for text in problem_texts:
		# bbcode like [hint=...] is not included when calculating text width
		var string = strip_bbcode(TranslationServer.translate(text.text))
		if text_font.get_string_size(string, HORIZONTAL_ALIGNMENT_LEFT, -1, text.get_theme_font_size("normal_font_size")).x > MAX_PROBLEM_TEXT_WIDTH:
			# set text autowarp if its width exceeds MAX_TEXT_WIDTH
			text.set_autowrap_mode(TextServer.AUTOWRAP_WORD_SMART)
			text.set_custom_minimum_size(Vector2(MAX_PROBLEM_TEXT_WIDTH, 0))
		else:
			text.set_autowrap_mode(TextServer.AUTOWRAP_OFF)
			text.set_custom_minimum_size(Vector2(0, 0))
	for text in option_texts:
		var string = strip_bbcode(TranslationServer.translate(text.text))
		if text_font.get_string_size(string, HORIZONTAL_ALIGNMENT_LEFT, -1, text.get_theme_font_size("normal_font_size")).x > MAX_OPTION_TEXT_WIDTH:
			text.set_autowrap_mode(TextServer.AUTOWRAP_WORD_SMART)
			text.set_custom_minimum_size(Vector2(MAX_OPTION_TEXT_WIDTH, 0))
		else:
			text.set_autowrap_mode(TextServer.AUTOWRAP_OFF)
			text.set_custom_minimum_size(Vector2(0, 0))


func check_and_shrink_font():
	var size = problems_container.get_minimum_size()
	if size.y > MAX_TEXT_HEIGHT:
		for text in texts:
			text.set_theme(extra_small_text_style)
		update_word_warp()
