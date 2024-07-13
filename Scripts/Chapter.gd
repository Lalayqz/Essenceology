extends Node

@onready var window_size = get_viewport().size
@onready var chapter_size = $Map/Background.size
@onready var MAP = $Map
var drag_start_last_frame = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var chapters_bar = get_node("../Chapters_Bar")
	var chapters_bar_width = chapters_bar.size.x if chapters_bar.visible else 0
	
	self.position.x = chapters_bar_width
	MAP.position = Global_Variables.get_map_drag_pos()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if (event is InputEventMouseButton):
		if (event.pressed):
			drag_start_last_frame = event.position
		else:
			drag_start_last_frame = null
	elif (event is InputEventMouseMotion):
		if (drag_start_last_frame != null):
			MAP.position += event.position - drag_start_last_frame
			MAP.position.x = max(MAP.position.x, window_size.x - chapter_size.x)  # lower limit
			MAP.position.x = min(MAP.position.x, 0)  # upper limit
			MAP.position.y = max(MAP.position.y, window_size.y - chapter_size.y)
			MAP.position.y = min(MAP.position.y, 0)
			drag_start_last_frame = event.position
			
func _exit_tree():
	Global_Variables.set_map_drag_pos(MAP.position)
