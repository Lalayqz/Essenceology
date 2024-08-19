extends Level

var PROBLEM_TEXTS = []
var MAX_TEXT_WIDTH = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	
	for problem in PROBLEMS:
		PROBLEM_TEXTS.append(problem.get_node("Problem/Text/Text/Text"))
	
	# set text autowarp if its width exceeds MAX_TEXT_WIDTH
	var word_warp = false
	for problem_text in PROBLEM_TEXTS:
		# bbcode like [hint=...] is not included when calculating text width
		var string = strip_bbcode(TranslationServer.translate(problem_text.text))
		if TEXT_FONT.get_string_size(string, 0, -1, TEXT_FONT_SIZE).x > MAX_TEXT_WIDTH:
			problem_text.set_autowrap_mode(TextServer.AUTOWRAP_WORD)
			problem_text.set_custom_minimum_size(Vector2(MAX_TEXT_WIDTH, 0))
			break

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
