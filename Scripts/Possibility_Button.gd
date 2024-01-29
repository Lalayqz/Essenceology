extends "Button.gd"

enum Possibilities {
	None = 0,
	P = 1,
	NP = 2,
}

signal state_changed()
@onready var P_SPRITE = $P
@onready var NP_SPRITE = $NP
var possibility = Possibilities.None
var is_left_click

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func button_down():
	self.modulate = Color.WEB_GRAY
	is_left_click = Input.is_action_pressed("left_click")
	
func pressed():
	if is_left_click:
		if possibility == Possibilities.P:
			switch_to(Possibilities.None)
		else:
			switch_to(Possibilities.P)
	else:
		if possibility == Possibilities.NP:
			switch_to(Possibilities.None)
		else:
			switch_to(Possibilities.NP)

func switch_to(p):
	possibility = p as Possibilities  # if not using "as", then possibility may be assigned by an int, which won't work in the next "match" sentence
	for sprite in get_children():
		sprite.visible = false
	match possibility:
		Possibilities.P:
			P_SPRITE.visible = true
		Possibilities.NP:
			NP_SPRITE.visible = true
	state_changed.emit()
			
func is_not_answered():
	return possibility == Possibilities.None
	
func check_answer():
	return possibility == Possibilities.get(get_meta("answer"))
	
