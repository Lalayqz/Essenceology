class_name NeatButton extends BaseButton

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func return_normal():
	self.modulate = Color.WHITE

func hovered():
	if not disabled:
		self.modulate = Color.GRAY
	
func button_down():
	self.modulate = Color.WEB_GRAY

func released():
	if is_hovered():
		hovered()
	else:
		return_normal()

