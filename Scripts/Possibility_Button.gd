class_name PossibilityButton extends NeatButton

signal answer_changed()
enum Possibilities {
	P,
	NP,
}
@export var reference_answer: Possibilities
var possibility = null
var is_left_click
@onready var p_sprite = $P
@onready var np_sprite = $NP


func button_down():
	self.modulate = Color.WEB_GRAY
	is_left_click = Input.is_action_pressed("left_click")


func pressed():
	if is_left_click:
		if possibility == Possibilities.P:
			switch_to(null)
		else:
			switch_to(Possibilities.P)
	else:
		if possibility == Possibilities.NP:
			switch_to(null)
		else:
			switch_to(Possibilities.NP)


func switch_to(p):
	var p_old = possibility
	possibility = p as Possibilities if p != null else null # if not using "as", then possibility may be assigned by an int, which won't work in the next "match" sentence
		
	for sprite in get_children():
		sprite.visible = false
	match possibility:
		Possibilities.P:
			p_sprite.visible = true
		Possibilities.NP:
			np_sprite.visible = true
	
	if p != p_old:
		answer_changed.emit()
