class_name ShouldButton extends NeatButton

signal answer_changed()
signal answer_set_to_should()
@export var REFERENCE_ANSWER: bool
@onready var SHOULD_SPRITE = $Should
var should = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func button_down():
	self.modulate = Color.WEB_GRAY
	
func pressed():
	switch()

func switch():
	switch_to(not should)
	
func switch_to(s):
	var s_old = should
	should = s
	SHOULD_SPRITE.visible = s
	
	if s != s_old:
		answer_changed.emit()
		if s:
			answer_set_to_should.emit()
		
func get_answer():
	return should