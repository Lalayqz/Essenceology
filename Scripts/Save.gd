extends Node

var SAVE_PATH = "user://savegame.save"
var save
var levels_solved
var levels_lockdown_time
var levels_inputs

# Called when the node enters the scene tree for the first time.
func _ready():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var json = JSON.new()
		json.parse(file.get_as_text())
		save = json.get_data()
	else:
		save = {"levels_solved":[], "levels_lockdown_time":{}, "levels_inputs":{}}
	levels_solved = save["levels_solved"]
	levels_lockdown_time = save["levels_lockdown_time"]
	levels_inputs = save["levels_inputs"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_is_level_solved(name):
	return name in levels_solved
	
func get_level_inputs(name):
	if name in levels_inputs:
		return levels_inputs[name]
	else:
		return null
	
func set_level_solved(name):
	levels_solved.append(name)
	save_game()
	
func set_level_inputs(name, inputs):
	levels_inputs[name] = inputs
	save_game()
	
func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_line(JSON.stringify(save))
