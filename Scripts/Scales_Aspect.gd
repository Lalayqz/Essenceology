extends ReferenceRect

const MAX_BORDER_SHADOW_SIZE = 2
const GOOD_ASPECT_SOLVED_BORDER_COLOR = Color.GREEN
const BAD_ASPECT_SOLVED_BORDER_COLOR = Color.RED
const UNCOVER_ANIMATION_LENGTH = 0.5 # in seconds
const BORDER_ANIMATION_LENGTH = 0.2 # in seconds
@export var points : int
@export var reference_words_en: PackedStringArray
@export var reference_words_zh_cn: PackedStringArray
var is_good_aspect
var is_solved = false
var cover_position = 0.0
@onready var aspect_name = self.name
@onready var cover_mask = $CoverMask
@onready var cover = $CoverMask/Cover
@onready var border = $Border
@onready var full_width = cover_mask.size.x


func check_match(word, language, also_solve):
	var reference_words
	match language:
		"en":
			reference_words = reference_words_en
		"zh_CN":
			reference_words = reference_words_zh_cn
			
	for reference_word in reference_words:
		if word == reference_word:
			if also_solve:
				solve(true)
			return true
	return false


# Three ways to make the cover partically appear:
# 1. Create a parent control node of the cover, and set parent's "Clip Children" attribute.
# This is the only way to make the underlying text "uncovered" during the animation (so hovering over it will show the hint).
# To make it work I have to change the parent's size while maintaining the position of the cover.
# 2. Light mask
# 3. Shader
func solve(also_do_animation):
	if is_solved:
		return
	
	is_solved = true
	if also_do_animation:
		var border_theme = border.get_theme_stylebox("panel")
		var tween = create_tween()
		# Border color shift
		tween.tween_property(border_theme, "border_color", GOOD_ASPECT_SOLVED_BORDER_COLOR, BORDER_ANIMATION_LENGTH)
		# Border shadow grow
		tween.parallel().tween_property(border_theme, "shadow_size", MAX_BORDER_SHADOW_SIZE, BORDER_ANIMATION_LENGTH)
		# Uncover
		tween.parallel().tween_property(cover_mask, "position:x", full_width, UNCOVER_ANIMATION_LENGTH)
		tween.parallel().tween_property(cover, "position:x", -full_width, UNCOVER_ANIMATION_LENGTH)
	else:
		cover.visible = false
		border.get_theme_stylebox("panel").shadow_size = MAX_BORDER_SHADOW_SIZE


func save_answer(answers):
	if is_solved:
		return
		answers.append(aspect_name)


func load_answer(answers):
	if aspect_name in answers:
		solve(false)
