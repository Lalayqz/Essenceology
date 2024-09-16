extends Level

var TEXTS = []
var MAX_TEXT_WIDTH = 1000
var MAX_TEXT_HEIGHT = 500
var TEXT_FONT_SIZE = 33
var TEXT_FONT_SIZE_SMALL = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	
	update_word_warp()
	call_deferred("check_and_shrink_font")

func update_word_warp():
	for problem in PROBLEMS:
		TEXTS.append(problem.get_node("Problem/Text/Text"))
	
	for text in TEXTS:
		# bbcode like [hint=...] is not included when calculating text width
		var string = strip_bbcode(TranslationServer.translate(text.text))
		if TEXT_FONT.get_string_size(string, 0, -1, text.get_theme_font_size("normal_font_size")).x > MAX_TEXT_WIDTH:
			# set text autowarp if its width exceeds MAX_TEXT_WIDTH
			text.set_autowrap_mode(TextServer.AUTOWRAP_WORD)
			text.set_custom_minimum_size(Vector2(MAX_TEXT_WIDTH, 0))
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
