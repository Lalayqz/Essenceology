extends Node2D

@onready var CHAPTER = Global_Variables.current_chapter
@onready var TEXTS = get_tree().get_nodes_in_group("Texts")
@onready var PROBLEMS = get_node("Problems/Problems")
var TEXT_FONT = preload("res://Resources/SourceHanSansSC-Normal.otf")
var TEXT_FONT_SIZE = 33
var TEXT_FONT_SIZE_SMALL = 30
var MAX_TEXT_WIDTH = 1000
var MAX_TEXT_HEIGHT = 500
signal solve_level()

# Called when the node enters the scene tree for the first time.
func _ready():
	$UI/Title.text = self.name
	# text layout (according to localization)
	var word_warp = false
	for text in TEXTS:
		if TEXT_FONT.get_string_size(TranslationServer.translate(text.text), 0, -1, TEXT_FONT_SIZE).x > MAX_TEXT_WIDTH:
			word_warp = true
			break
	if word_warp:
		for text in TEXTS:
			text.set_autowrap_mode(TextServer.AUTOWRAP_WORD)
			text.set_custom_minimum_size(Vector2(MAX_TEXT_WIDTH, 0))
	call_deferred("check_and_shrink_font")
	# saved inputs
	var saved_inputs = Save.get_level_inputs(CHAPTER, self.name)
	if saved_inputs != null:
		var input_nodes = get_tree().get_nodes_in_group("Inputs")
		var length = min(len(saved_inputs), len(input_nodes))
		for i in range(length):
			input_nodes[i].switch_to(saved_inputs[i])
	# solved
	if Save.get_level_solved(CHAPTER, self.name):
		solve_level.emit()
	
func check_and_shrink_font():
	var size = PROBLEMS.get_minimum_size()
	if size.y > MAX_TEXT_HEIGHT:
		for text in TEXTS:
			text.set("theme_override_font_sizes/font_size", TEXT_FONT_SIZE_SMALL)
						
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		exit_level()

func _notification(notification):
	if notification == NOTIFICATION_WM_CLOSE_REQUEST:
		exit_level()

func save_inputs():
	var inputs = []
	for input in get_tree().get_nodes_in_group("Inputs"):
		inputs.append(input.possibility)
	Save.set_level_inputs(CHAPTER, self.name, inputs)
	Save.save_game()

func exit_level():
	save_inputs()
	get_tree().change_scene_to_file("res://MainMenu.tscn")
