class_name ChapterButton extends NeatButton

@export_enum("POSSIBILITY", "SHOULD", "DEFINITION") var chapter : String
@onready var main_menu = get_node("../..")


func _pressed():
	main_menu.load_chapter(chapter)
