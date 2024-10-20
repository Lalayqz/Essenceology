extends Node2D

const SHIFT_TIME = 10
const START_SCALE = 1
const MAX_END_SCALE = 2
const SCALE_SHIFT_SPEED = float(MAX_END_SCALE - START_SCALE) / SHIFT_TIME
const ALPHA_SHIFT_SPEED = 1. / SHIFT_TIME
const MOVING_SPEED = 0.15
const SMALL_LIGHT_ALPHA = 0.4
const NEW_LIGHT_INTERVAL = 15
const LIGHT_FADE_DELAY = 5
const LIGHT_COLORS = {"SETTINGS": 0xa66df5ff, "CORRECT_ANSWER":0x00ff00ff, "WRONG_ANSWER":0xff0000ff, "POSSIBILITY": 0x55b555ff, "SHOULD": 0xffb012ff}
const COLOR_SHIFT_SPEED_FAST = 5
const COLOR_SHIFT_SPEED_SLOW = 1

var light_texture = preload("res://resources/images/light.png")
var color = Color(LIGHT_COLORS["POSSIBILITY"]) # controls colors of all lights!
var target_color = color
var color_shift_speed
var is_light_on
var view_size
var light_count
var rng = RandomNumberGenerator.new()
var new_light_counter = 0
var small_light_counter = 0


func _ready():
	is_light_on = Config.get_disturbing_background()
	view_size = get_viewport().content_scale_size
	light_count = view_size.x * view_size.y / 130000
	if is_light_on:
		init_lights()


func _process(delta):
	if is_light_on:
		new_light_counter = new_light_counter + delta
		if (new_light_counter > NEW_LIGHT_INTERVAL):
			new_light_counter -= NEW_LIGHT_INTERVAL
			fade_first_light()
			add_light(true)
		for light in get_children():
			update_light(light, delta)
			
		color.r = color.r + (target_color.r - color.r) * color_shift_speed * delta
		color.g = color.g + (target_color.g - color.g) * color_shift_speed * delta
		color.b = color.b + (target_color.b - color.b) * color_shift_speed * delta	
		set_light_color(color)


func init_lights():
	is_light_on = true
	color = target_color
	for i in range(light_count):
		add_light(false)


func add_light(is_growing):
	var light = Sprite2D.new()
	light.texture = light_texture
	light.position = Vector2(rng.randi_range(0, view_size.x), rng.randi_range(0, view_size.y))
	
	light.modulate = color
	var max_alpha
	small_light_counter += 1
	if (small_light_counter == 2):
		max_alpha = SMALL_LIGHT_ALPHA
		small_light_counter = 0
	else:
		max_alpha = 1
	light.set_meta("max_alpha", max_alpha)
	light.modulate.a = 0 if is_growing else max_alpha
	var max_scale = START_SCALE if is_growing else START_SCALE + max_alpha * (MAX_END_SCALE - START_SCALE)
	light.scale = Vector2(max_scale, max_scale)
	
	light.set_meta("is_fading", false)
	if (rng.randi_range(0, 2) == 0):
		light.set_meta("speed", MOVING_SPEED)
		var angle = rng.randf_range(-PI, PI)
		light.set_meta("direction", Vector2(cos(angle), sin(angle)))
	else:
		light.set_meta("speed", 0)
	add_child(light)


func update_light(light, delta):
	var light_scale = light.get_scale().x
	var alpha = light.modulate.a
	var is_fading = light.get_meta("is_fading")
	if not is_fading:
		var max_alpha = light.get_meta("max_alpha")
		if alpha < max_alpha:
			light_scale += delta * SCALE_SHIFT_SPEED
			light.scale = Vector2(light_scale, light_scale)
			light.modulate.a += delta * ALPHA_SHIFT_SPEED
	else:
		var countdown = light.get_meta("fading_countdown")
		if countdown > 0:
			light.set_meta("fading_countdown", countdown - delta)
		else:
			light_scale -= delta * SCALE_SHIFT_SPEED
			light.scale = Vector2(light_scale, light_scale)
			if alpha > 0:
				light.modulate.a -= delta * ALPHA_SHIFT_SPEED
			else:
				light.queue_free()
				
	var speed = light.get_meta("speed")
	if speed > 0:
		var direction =  light.get_meta("direction")
		light.position += speed * direction


func fade_first_light():
	for light in get_children():
		if not light.get_meta("is_fading"):
			light.set_meta("is_fading", true)
			light.set_meta("fading_countdown", LIGHT_FADE_DELAY)
			return


func turn_off_lights():
	is_light_on = false
	for light in get_children():
		remove_child(light)
		light.queue_free()


func set_light_color(c):
	color = c
	for light in get_children():
		light.modulate.r = color.r
		light.modulate.g = color.g
		light.modulate.b = color.b


func update_color_to_chapter_color(chapter):
	target_color = Color(LIGHT_COLORS[chapter])
	color_shift_speed = COLOR_SHIFT_SPEED_FAST


func color_flash(chapter, color_code):
	# set current color to wrong answer color
	color = Color(LIGHT_COLORS[color_code])
	set_light_color(color)
	# set target color to chapter color
	target_color = Color(LIGHT_COLORS[chapter])
	color_shift_speed = COLOR_SHIFT_SPEED_SLOW
