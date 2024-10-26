class_name LevelWithProgressBar extends Level

const PROGRESS_BAR_UPDATE_DUARTION = 0.4
@export var points_goal: int
@export var show_progress_bar: bool
@onready var progress_bar = level_structure.get_node("Ui/ProgressBar")


func _ready():
	problems.append(get_node("Body/Body/Problem").get_child(0))
	
	super()
	
	progress_bar.visible = show_progress_bar
	update_progress_bar(false)


func get_points():
	var points = 0
	for problem in problems:
		points += problem.get_points()
	return points


func update_progress_bar(also_do_animation_and_save):
	var points = get_points()
		
	if points >= points_goal:
		progress_bar.visible = false
		solve_level(also_do_animation_and_save)
	else:
		var full_width = progress_bar.get_node("Border").size.x
		var target_width = full_width * points / points_goal
		var bar = progress_bar.get_node("Border/Bar")
		if also_do_animation_and_save:
			var tween = create_tween()
			tween.tween_property(bar, "size:x", target_width, PROGRESS_BAR_UPDATE_DUARTION)
		else:
			bar.size.x = target_width


func should_be_solved():
	return get_points() >= points_goal


func solve_level(also_save):
	super(also_save)
	
	progress_bar.hide()
