extends CenterContainer

@export var REFERENCE_WORDS_EN: PackedStringArray
@export var REFERENCE_WORDS_ZH_CN: PackedStringArray

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func check_match(word, language):
	var reference_words
	match language:
		"en":
			reference_words = REFERENCE_WORDS_EN
		"zh_CN":
			reference_words = REFERENCE_WORDS_ZH_CN
			
	for reference_word in reference_words:
		if word == reference_word:
			solve()		

func solve():
	pass
