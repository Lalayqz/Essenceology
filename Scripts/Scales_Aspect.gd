extends CenterContainer

@onready var ASPECT_NAME = self.name
@onready var Cover = $Cover
@export var REFERENCE_WORDS_EN: PackedStringArray
@export var REFERENCE_WORDS_ZH_CN: PackedStringArray
var answered = false

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
			return true
	return false

func switch_to(a):
	answered = a
	Cover.visible = not answered
	
func save_answer(answers):
	if answered:
		answers.append(ASPECT_NAME)
	
func load_answer(answers):
	if ASPECT_NAME in answers:
		switch_to(true)
		
func solve():
	switch_to(true)
