extends Node2D

signal solve_level()
@onready var SAVE_NODE = get_node("/root/Save")

# Called when the node enters the scene tree for the first time.
func _ready():
	$UI/Title.text = self.name
	# saved inputs
	var saved_inputs = SAVE_NODE.get_level_inputs(self.name)
	if saved_inputs != null:
		var input_nodes = get_tree().get_nodes_in_group("Inputs")
		var length = min(len(saved_inputs), len(input_nodes))
		for i in range(length):
			input_nodes[i].switch_to(saved_inputs[i])
	# solved
	if SAVE_NODE.get_is_level_solved(self.name):
		solve_level.emit()
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		exit_level()

func exit_level():
	var inputs = []
	for input in get_tree().get_nodes_in_group("Inputs"):
		inputs.append(input.possibility)
	SAVE_NODE.set_level_inputs(self.name, inputs)
	get_tree().change_scene_to_file("res://MainMenu.tscn")
