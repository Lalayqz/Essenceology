extends Node
 
var aspects = []
@onready var problem_name = self.name


func _ready():
	for aspect in $Aspects/GoodAspects.get_children():
		aspects.append(aspect)
		aspect.is_good_aspect = true
	for aspect in $Aspects/BadAspects.get_children():
		aspects.append(aspect)
		aspect.is_good_aspect = false


func check_match_aspects(text, language):
	var matched = false
	
	for aspect in aspects:
		if aspect.check_match(text, language):
			matched = true
			
	return matched


func save_answer(chapter, level_name):
	var answers = []
	for aspect in aspects:
		aspect.save_answer(answers)
	Save.save_problem_answer(chapter, level_name, problem_name, answers)


func load_answer(chapter, level_name):
	var answers = Save.get_problem_answer(chapter, level_name, problem_name)
	if answers != null:
		for aspect in aspects:
			aspect.load_answer(answers)


func get_points():
	var points = 0
	for aspect in aspects:
		if aspect.is_solved:
			points += aspect.points
	return points
