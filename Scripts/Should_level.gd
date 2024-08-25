extends Level

@onready var PROBLEMS_CENTER_CONTAINER = $Problems
var PROBLEM_TEXTS = []
var TEXTS = []
var MAX_TEXT_WIDTH = 1000
var MAX_TEXT_HEIGHT = 450
var TEXT_FONT_SIZE_SMALL = 26

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	
	for problem in PROBLEMS:
		var problem_text = problem.get_node("Problem/Text/Text/Text")
		var options = problem.get_node("Problem/Options").get_children()
		PROBLEM_TEXTS.append(problem_text)
		TEXTS.append(problem_text)
		for option in options:
			var option_text = option.get_node("Text/Text")
			TEXTS.append(option_text)
	
	update_word_warp()
	call_deferred("check_and_shrink_font")

func update_word_warp():
	# set text autowarp if its width exceeds MAX_TEXT_WIDTH
	var word_warp = false
	for text in PROBLEM_TEXTS:
		# bbcode like [hint=...] is not included when calculating text width
		var string = strip_bbcode(TranslationServer.translate(text.text))
		if TEXT_FONT.get_string_size(string, 0, -1, text.get("theme_override_font_sizes/normal_font_size")).x > MAX_TEXT_WIDTH:
			word_warp = true
			break
	if word_warp:
		for text in PROBLEM_TEXTS:
			text.set_autowrap_mode(TextServer.AUTOWRAP_WORD)
			text.set_custom_minimum_size(Vector2(MAX_TEXT_WIDTH, 0))
	else:
		for text in PROBLEM_TEXTS:
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
