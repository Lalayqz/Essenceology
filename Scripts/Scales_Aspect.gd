extends ReferenceRect

const UNCOVER_SPEED = 500
const BORDER_COLOR_SHIFT_SPEED = 10
const MAX_BORDER_SHADOW_SIZE = 5
const BORDER_ANIM_MAX_TIME = 0.2 # in seconds
@export var reference_words_en: PackedStringArray
@export var reference_words_zh_cn: PackedStringArray
var full_width
var answered = false
var ongoing_cover_anim = false
var ongoing_border_anim = false
var cover_anim_progress = 0.0
var border_anim_progress = 0 # From 0 to BORDER_ANIM_MAX_TIME
var cover_position = 0.0
@onready var aspect_name = self.name
@onready var cover_mask = $CoverMask
@onready var cover = $CoverMask/Cover
@onready var border = $Border


func _ready():
	full_width = cover_mask.size.x


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
		if cover_anim_progress < full_width:
			cover_mask.position.x = cover_anim_progress
			cover.position.x = cover_position
		else:
			cover_mask.position.x = full_width
			cover.position.x = -full_width
			ongoing_cover_anim = false
			
	# Border color shift & shadow grow
	if ongoing_border_anim:
		border_anim_progress += delta
		if border_anim_progress < BORDER_ANIM_MAX_TIME:
			var progress_percentage = border_anim_progress / BORDER_ANIM_MAX_TIME
			
			border.get_theme_stylebox("panel").shadow_size = MAX_BORDER_SHADOW_SIZE * progress_percentage
		else:
			ongoing_border_anim = false
			border.get_theme_stylebox("panel").shadow_size = MAX_BORDER_SHADOW_SIZE


func check_match(word, language):
	var reference_words
	match language:
		"en":
			reference_words = reference_words_en
		"zh_CN":
			reference_words = reference_words_zh_cn
			
	for reference_word in reference_words:
		if word == reference_word:
			return true
	return false


func switch_to(a):
	answered = a
	cover.visible = not answered


func save_answer(answers):
	if answered:
		answers.append(aspect_name)


func load_answer(answers):
	if aspect_name in answers:
		switch_to(true)


func solve():
	ongoing_cover_anim = true
	ongoing_border_anim = true
