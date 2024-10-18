extends Node

const CONFIG_PATH = "user://config.cfg"
var config


func _ready():
	config = ConfigFile.new()
	if config.load(CONFIG_PATH) != OK:
		config.set_value("Config", "disturbing_background", true)
	else:
		var language = config.get_value("Config", "language")
		if language != null:
			TranslationServer.set_locale(language)
			
	get_window().set_ime_active(true)
	update_window_title()

func get_language():  # can be null
	return config.get_value("Config", "language")


func get_disturbing_background():
	return config.get_value("Config", "disturbing_background")


func set_language(language):
	config.set_value("Config", "language", language)
	TranslationServer.set_locale(language)
	update_window_title()


func set_disturbing_background(is_on):
	config.set_value("Config", "disturbing_background", is_on)


func save_config():
	config.save(CONFIG_PATH)


func update_window_title():
	if TranslationServer.get_locale() == 'zh_CN':
		DisplayServer.window_set_title('本质学')
	else:
		DisplayServer.window_set_title('Essenceology')
