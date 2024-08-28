extends Level

@onready var PROBLEMS_CENTER_CONTAINER = $Problems
var TEXTS = []
var MAX_PROBLEM_TEXT_WIDTH = 1000
var MAX_OPTION_TEXT_WIDTH = 550
var MAX_TEXT_HEIGHT = 525
var TEXT_FONT_SIZE = 26
var TEXT_FONT_SIZE_SMALL = 24

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	
	update_word_warp()
	call_deferred("check_and_shrink_font")

func update_word_warp():
	var problem_texts = []
	var option_texts = []
	
	for problem in PROBLEMS:
		var problem_text = problem.get_node("Problem/Text/Text/Text")
		var options = problem.get_node("Problem/Options").get_children()
		problem_texts.append(problem_text)
		TEXTS.append(problem_text)
		for option in options:
			var option_text = option.get_node("Text/Text/Text")
			option_texts.append(option_text)
			TEXTS.append(option_text)
	
	for text in problem_texts:
		# bbcode like [hint=...] is not included when calculating text width
		var string = strip_bbcode(TranslationServer.translate(text.text))
		if TEXT_FONT.get_string_size(string, 0, -1, text.get("theme_override_font_sizes/normal_font_size")).x > MAX_PROBLEM_TEXT_WIDTH:
			# set text autowarp if its width exceeds MAX_TEXT_WIDTH
			text.set_autowrap_mode(TextServer.AUTOWRAP_WORD)
			text.set_custom_minimum_size(Vector2(MAX_PROBLEM_TEXT_WIDTH, 0))
		else:
			text.set_autowrap_mode(TextServer.AUTOWRAP_OFF)
			text.set_custom_minimum_size(Vector2(0, 0))
	for text in option_texts:
		var string = strip_bbcode(TranslationServer.translate(text.text))
		if TEXT_FONT.get_string_size(string, 0, -1, text.get("theme_override_font_sizes/normal_font_size")).x > MAX_OPTION_TEXT_WIDTH:
			text.set_autowrap_mode(TextServer.AUTOWRAP_WORD)
			text.set_custom_minimum_size(Vector2(MAX_OPTION_TEXT_WIDTH, 0))
		else:
			text.set_autowrap_mode(TextServer.AUTOWRAP_OFF)
			text.set_custom_minimum_size(Vector2(0, 0))

func check_and_shrink_font():
	var size = PROBLEMS_CONTAINER.get_minimum_size()
	if size.y > MAX_TEXT_HEIGHT:
		for text in TEXTS:
			text.set("theme_override_font_sizes/normal_font_size", TEXT_FONT_SIZE_SMALL)
		update_word_warp()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
