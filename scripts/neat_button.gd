class_name NeatButton extends BaseButton


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
