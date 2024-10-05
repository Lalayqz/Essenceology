extends Node2D

@onready var config = Config.config
@onready var language_checkboxes = [$Options/Options/Lanaguages/Lanaguages/Lanaguages/En/En/Checkbox, $Options/Options/Lanaguages/Lanaguages/Lanaguages/Zh/Zh/Checkbox]
@onready var lights = Lights


func _ready():
	match TranslationServer.get_locale():
		"en":
			language_checkboxes[0].set_pressed_no_signal(true)
		"zh_CN":
			language_checkboxes[1].set_pressed_no_signal(true)
	
	var disturbing_background = Config.get_disturbing_background()
	if disturbing_background:
		$Options/Options/DisturbingBackground/DisturbingBackground/Checkbox.set_pressed_no_signal(true)


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		exit_settings()


func _notification(notification):
	if notification == NOTIFICATION_WM_CLOSE_REQUEST:
		exit_settings()


func exit_settings():
	Config.save_config()
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")


func update_language_en(is_on):
	if is_on:
		TranslationServer.set_locale("en")
		Config.set_language("en")
		for checkbox in language_checkboxes:
			checkbox.set_pressed_no_signal(false)
	language_checkboxes[0].set_pressed_no_signal(true)


func update_language_zh(is_on):
	if is_on:
		TranslationServer.set_locale("zh_CN")
		Config.set_language("zh_CN")
		for checkbox in language_checkboxes:
			checkbox.set_pressed_no_signal(false)
	language_checkboxes[1].set_pressed_no_signal(true)


func update_disturbing_background(is_on):
	Config.set_disturbing_background(is_on)
	if is_on:
		lights.init_lights()
	else:
		lights.turn_off_lights()
