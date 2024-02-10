extends Node

var SAVE_PATH = "user://essenceology.save"
var save
var levels_solved
var levels_penalty
var levels_inputs
var levels_fails

# Called when the node enters the scene tree for the first time.
func _ready():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var json = JSON.new()
		json.parse(file.get_as_text())
		save = json.get_data()
	else:
		save = {"version":0.1, "levels_solved":{}, "levels_inputs":{}, "levels_fails":{}, "levels_penalty":{}}
	levels_solved = save["levels_solved"]
	levels_inputs = save["levels_inputs"]
	levels_fails = save["levels_fails"]
	levels_penalty = save["levels_penalty"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for chapter in levels_penalty:
		var penalties_to_remove_in_chapter = []
		var chapter_penalties = levels_penalty[chapter]
		for penalty in chapter_penalties:
			var penalty_new = chapter_penalties[penalty] - delta
			if penalty_new <= 0:
				penalties_to_remove_in_chapter.append(penalty)
			else:
				chapter_penalties[penalty] = penalty_new
		for penalty in penalties_to_remove_in_chapter:
			chapter_penalties.erase(penalty)
	
func get_level_solved(chapter, level):
	var chapter_name = Global_Variables.Chapters.keys()[chapter]
	return chapter_name in levels_solved and level in levels_solved[chapter_name]
	
func get_level_inputs(chapter, level):
	var chapter_name = Global_Variables.Chapters.keys()[chapter]
	if chapter_name in levels_inputs and level in levels_inputs[chapter_name]:
		return levels_inputs[chapter_name][level]
	else:
		return null
		
func get_level_fail(chapter, level):
	var chapter_name = Global_Variables.Chapters.keys()[chapter]
	if chapter_name in levels_fails and level in levels_fails[chapter_name]:
		return levels_fails[chapter_name][level]
	else:
		return 0
		
func get_level_penalty(chapter, level):
	var chapter_name = Global_Variables.Chapters.keys()[chapter]
	if chapter_name in levels_penalty and level in levels_penalty[chapter_name]:
		return levels_penalty[chapter_name][level]
	else:
		return 0
	
func set_level_solved(chapter, level):
	var chapter_name = Global_Variables.Chapters.keys()[chapter]
	if chapter_name not in levels_solved:
		levels_solved[chapter_name] = []
	levels_solved[chapter_name].append(level)
	save_game()
	
func set_level_inputs(chapter, level, inputs):
	var chapter_name = Global_Variables.Chapters.keys()[chapter]
	if chapter_name not in levels_inputs:
		levels_inputs[chapter_name] = {}
	levels_inputs[chapter_name][level] = inputs
	save_game()
	
func set_level_fail(chapter, level, count):
	var chapter_name = Global_Variables.Chapters.keys()[chapter]
	if chapter_name not in levels_fails:
		levels_fails[chapter_name] = {}
	levels_fails[chapter_name][level] = count
	save_game()
	
func set_level_penalty(chapter, level, time):
	var chapter_name = Global_Variables.Chapters.keys()[chapter]
	if chapter_name not in levels_penalty:
		levels_penalty[chapter_name] = {}
	levels_penalty[chapter_name][level] = time
	save_game()
	
func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_line(JSON.stringify(save))
