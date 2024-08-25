extends Level

var TEXTS = []
var MAX_TEXT_WIDTH = 1000
var MAX_TEXT_HEIGHT = 500
var TEXT_FONT_SIZE = 33
var TEXT_FONT_SIZE_SMALL = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	
	for problem in PROBLEMS:
		TEXTS.append(problem.get_node("Problem/Text/Text"))
	
	# set text autowarp if its width exceeds MAX_TEXT_WIDTH
	var word_warp = false
	for text in TEXTS:
		# bbcode like [hint=...] is not included when calculating text width
		var string = strip_bbcode(TranslationServer.translate(text.text))
		if TEXT_FONT.get_string_size(string, 0, -1, TEXT_FONT_SIZE).x > MAX_TEXT_WIDTH:
			word_warp = true
			break
	if word_warp:
		for text in TEXTS:
			text.set_autowrap_mode(TextServer.AUTOWRAP_WORD)
			text.set_custom_minimum_size(Vector2(MAX_TEXT_WIDTH, 0))
			
	call_deferred("check_and_shrink_font")

func check_and_shrink_font():
	var size = PROBLEMS_CONTAINER.get_minimum_size()
	if size.y > MAX_TEXT_HEIGHT:
		for text in TEXTS:
			text.set("theme_override_font_sizes/normal_font_size", TEXT_FONT_SIZE_SMALL)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
