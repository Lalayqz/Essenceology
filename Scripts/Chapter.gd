extends Node

@onready var chapter_bar_width = get_node("../Chapters").size.x
@onready var window_size = get_viewport().size
@onready var chapter_size = $Background.size
var drag_start_last_frame = null

# Called when the node enters the scene tree for the first time.
func _ready():
	self.position.x = chapter_bar_width

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
			self.position += event.position - drag_start_last_frame
			self.position.x = max(self.position.x, window_size.x - chapter_size.x)  # lower limit
			self.position.x = min(self.position.x, chapter_bar_width)  # upper limit
			self.position.y = max(self.position.y, window_size.y - chapter_size.y)
			self.position.y = min(self.position.y, 0)
			drag_start_last_frame = event.position
