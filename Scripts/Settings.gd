extends Node2D

@onready var config_node = get_node("/root/Config")
@onready var config = config_node.config
@onready var lights_node = $Lights

# Called when the node enters the scene tree for the first time.
func _ready():
	var disturbing_background = config_node.config.get_value("Config", "disturbing_background")
	if disturbing_background:
		$Inputs/disturbing_background.set_pressed_no_signal(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		exit_options()

func exit_options():
	config_node.save_config()
	get_tree().change_scene_to_file("res://MainMenu.tscn")
	
func update_disturbing_background(is_on):
	config_node.config.set_value("Config", "disturbing_background", is_on)
	if is_on:
		lights_node.init_lights()
	else:
		lights_node.remove_all_lights()
