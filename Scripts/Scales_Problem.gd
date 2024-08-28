extends Node
 
@onready var PROBLEM_NAME = self.name
@onready var LANGUAGE = Config.get_language()
@onready var INPUT = $Input/Input

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _input(event):
	if event is InputEventKey and event.unicode != 0:
		
		INPUT.text += event.as_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func is_correct():
	pass
	
func save_answer(chapter, level_name):
	pass
	
func load_answer(chapter, level_name):
	var answer = Save.get_problem_answer(chapter, level_name, PROBLEM_NAME)
	if answer != null:
		pass
