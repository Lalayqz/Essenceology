extends MarginContainer

const SHINE_MAX_BORDER_SHADOW_SIZE = 10
const ANSWERED_BORDER_SHADOW_SIZE = 2
const GOOD_ASPECT_SOLVED_BORDER_COLOR = Color.GREEN
const BAD_ASPECT_SOLVED_BORDER_COLOR = Color.RED
const UNCOVER_ANIMATION_LENGTH = 0.35
const BORDER_GROW_ANIMATION_LENGTH = 0.3
const BORDER_KEEP_ANIMATION_LENGTH = 1
const BORDER_SHRINK_ANIMATION_LENGTH = 0.8
@export var points : int
@export var reference_words_en: PackedStringArray
@export var reference_words_zh_cn: PackedStringArray
var is_good_aspect
var is_solved = false
var just_shone = false
var shine_tween = null
@onready var aspect_name = self.name
@onready var cover_mask = $Aspect/CoverMask
@onready var cover = $Aspect/CoverMask/Cover
@onready var border = $Aspect/Border
@onready var full_width = cover_mask.size.x


func _ready():
	var theme_duplicate = border.get_theme_stylebox('panel').duplicate()
	border.add_theme_stylebox_override('panel', theme_duplicate)

func check_match(word, language):
	var reference_words
	match language:
		"en":
			reference_words = reference_words_en
		"zh_CN":
			reference_words = reference_words_zh_cn
			
	for reference_word in reference_words:
		if word == reference_word:
			solve(true)
			return true
	just_shone = false
	return false


# Three ways to make the cover partically appear:
# 1. Create a parent control node of the cover, and set parent's "Clip Children" attribute.
# This is the only way to make the underlying text "uncovered" during the animation (so hovering over it will show the hint).
# To make it work I have to change the parent's size while maintaining the position of the cover.
# 2. Light mask
# 3. Shader
func solve(also_do_animation):
	if also_do_animation:
		shine()
	if is_solved:
		return
	
	is_solved = true
	if also_do_animation:
		var cover_tween = create_tween()
		cover_tween.tween_property(cover_mask, "position:x", full_width, UNCOVER_ANIMATION_LENGTH)
		cover_tween.parallel().tween_property(cover, "position:x", -full_width, UNCOVER_ANIMATION_LENGTH)
	else:
		cover.visible = false
		border.get_theme_stylebox("panel").shadow_size = ANSWERED_BORDER_SHADOW_SIZE


func shine():
	# If last input already matched this aspect, then don't shine.
	if just_shone:
		return
	
	# Clears the shine animation if there is currently one.
	if shine_tween != null:
		shine_tween.custom_step(BORDER_GROW_ANIMATION_LENGTH + BORDER_KEEP_ANIMATION_LENGTH + BORDER_SHRINK_ANIMATION_LENGTH)
	
	var border_theme = border.get_theme_stylebox("panel")
	shine_tween = create_tween()
	shine_tween.tween_property(border_theme, "border_color", GOOD_ASPECT_SOLVED_BORDER_COLOR if is_good_aspect else BAD_ASPECT_SOLVED_BORDER_COLOR, BORDER_GROW_ANIMATION_LENGTH)
	shine_tween.parallel().tween_property(border_theme, "shadow_size", SHINE_MAX_BORDER_SHADOW_SIZE, BORDER_GROW_ANIMATION_LENGTH).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
	shine_tween.tween_property(border_theme, "shadow_size", ANSWERED_BORDER_SHADOW_SIZE, BORDER_SHRINK_ANIMATION_LENGTH).set_trans(Tween.TRANS_BOUNCE).set_delay(BORDER_KEEP_ANIMATION_LENGTH)
	just_shone = true


func save_answer(answers):
	if is_solved:
		#answers.append(aspect_name)
		pass


func load_answer(answers):
	if aspect_name in answers:
		solve(false)
