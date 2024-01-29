extends Node2D

var CONFIG_PATH = "user://config.cfg"
var config

# Called when the node enters the scene tree for the first time.
func _ready():
	config = ConfigFile.new()
	if config.load(CONFIG_PATH) != OK:
		config.set_value("Config", "disturbing_background", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func save_config():
	config.save(CONFIG_PATH)
