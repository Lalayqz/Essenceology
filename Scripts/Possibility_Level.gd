extends LevelWithSubmitButton

const MAX_TEXT_WIDTH = 1000
const MAX_TEXT_HEIGHT = 500
var small_text_style = preload("res://resources/styles/problem_text_extra_small.tres")
var TEXTS = []


func _ready():
	super()
	
	update_word_warp()
	call_deferred("check_and_shrink_font")


func update_word_warp():
	for problem in problems:
		TEXTS.append(problem.get_node("Problem/Text/Text"))
	
	for text in TEXTS:
		# bbcode like [hint=...] is not included when calculating text width
		var string = strip_bbcode(TranslationServer.translate(text.text))
		if text_font.get_string_size(string, HORIZONTAL_ALIGNMENT_LEFT, -1, text.get_theme_font_size("normal_font_size")).x > MAX_TEXT_WIDTH:
			# set text autowarp if its width exceeds MAX_TEXT_WIDTH
			text.set_autowrap_mode(TextServer.AUTOWRAP_WORD_SMART)
			text.set_custom_minimum_size(Vector2(MAX_TEXT_WIDTH, 0))
		else:
			text.set_autowrap_mode(TextServer.AUTOWRAP_OFF)
			text.set_custom_minimum_size(Vector2(0, 0))


func check_and_shrink_font():
	var size = problems_container.get_minimum_size()
	if size.y > MAX_TEXT_HEIGHT:
		for text in TEXTS:
			text.set_theme(small_text_style)
		update_word_warp()
