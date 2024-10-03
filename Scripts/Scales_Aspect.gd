extends ReferenceRect

@onready var ASPECT_NAME = self.name
@onready var COVER_MASK = $Cover_Mask
@onready var COVER = $Cover_Mask/Cover
@onready var BORDER = $Border
# @onready var BORDER_INITIAL_COLOR = BORDER.modulate
@export var REFERENCE_WORDS_EN: PackedStringArray
@export var REFERENCE_WORDS_ZH_CN: PackedStringArray
var UNCOVER_SPEED = 500
var FULL_WIDTH
# var BRIGHT_BORDER_COLOR = Color(0x80ff80ff)
var BORDER_COLOR_SHIFT_SPEED = 10
var MAX_BORDER_SHADOW_SIZE = 5
var BORDER_ANIM_MAX_TIME = 0.2 # in seconds
var answered = false
var ongoing_cover_anim = false
var ongoing_border_anim = false
var cover_anim_progress = 0.0
var border_anim_progress = 0 # From 0 to BORDER_ANIM_MAX_TIME
var cover_position = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	FULL_WIDTH = COVER_MASK.size.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Cover Removal
	if ongoing_cover_anim:
	# Three ways to make the cover partically appear:
	# 1. Create a parent control node of the cover, and set parent's "Clip Children" attribute.
	# This is the only way to make the underlying text "uncovered" during the animation (so hovering over it will show the hint).
	# To make it work I have to change the parent's size while maintaining the position of the cover.
	# 2. Light mask
	# 3. Shader
	
		var displacement = delta * UNCOVER_SPEED
		cover_anim_progress += displacement
		cover_position -= displacement
		if cover_anim_progress < FULL_WIDTH:
			COVER_MASK.position.x = cover_anim_progress
			COVER.position.x = cover_position
		else:
			COVER_MASK.position.x = FULL_WIDTH
			COVER.position.x = -FULL_WIDTH
			ongoing_cover_anim = false
			
	# Border color shift & shadow grow
	if ongoing_border_anim:
		border_anim_progress += delta
		if border_anim_progress < BORDER_ANIM_MAX_TIME:
			var progress_percentage = border_anim_progress / BORDER_ANIM_MAX_TIME
			
			# BORDER.get_theme_stylebox("panel").border_color.r = BORDER_INITIAL_COLOR.r + (BRIGHT_BORDER_COLOR.r - BORDER_INITIAL_COLOR.r) * progress_percentage
			# BORDER.get_theme_stylebox("panel").border_color.g + (BRIGHT_BORDER_COLOR.g - BORDER_INITIAL_COLOR.g) * progress_percentage
			# BORDER.get_theme_stylebox("panel").border_color.b + (BRIGHT_BORDER_COLOR.r - BORDER_INITIAL_COLOR.r) * progress_percentage
			BORDER.get_theme_stylebox("panel").shadow_size = MAX_BORDER_SHADOW_SIZE * progress_percentage
		else:
			ongoing_border_anim = false
			# BORDER.get_theme_stylebox("panel").border_color = BRIGHT_BORDER_COLOR
			BORDER.get_theme_stylebox("panel").shadow_size = MAX_BORDER_SHADOW_SIZE
	
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
	COVER.visible = not answered
	
func save_answer(answers):
	if answered:
		answers.append(ASPECT_NAME)
	
func load_answer(answers):
	if ASPECT_NAME in answers:
		switch_to(true)
		
func solve():
	ongoing_cover_anim = true
	ongoing_border_anim = true
