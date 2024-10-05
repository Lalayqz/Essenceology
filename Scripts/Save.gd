extends Node

const SAVE_PATH = "user://essenceology.save"
var save
var chapter_solved
var level_solved
var problem_answer
var level_fail
var level_penalty


func _ready():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var json = JSON.new()
		json.parse(file.get_as_text())
		save = json.get_data()
	else:
		save = {"version":0.1, "chapter_solved":[], "level_solved":{}, "problem_answer":{}, "level_fail":{}, "level_penalty":{}}
	chapter_solved = save["chapter_solved"]
	level_solved = save["level_solved"]
	problem_answer = save["problem_answer"]
	level_fail = save["level_fail"]
	level_penalty = save["level_penalty"]


func _process(delta):
	for chapter in level_penalty:
		var penalties_to_remove_in_chapter = []
		var level_penalties = level_penalty[chapter]
		for penalty in level_penalties:
			var penalty_new = level_penalties[penalty] - delta
			if penalty_new <= 0:
				penalties_to_remove_in_chapter.append(penalty)
			else:
				level_penalties[penalty] = penalty_new
		for penalty in penalties_to_remove_in_chapter:
			level_penalties.erase(penalty)


func is_any_chapter_solved():
	return len(chapter_solved) > 0


func get_chapter_solved(chapter):
	return chapter in chapter_solved


func get_level_solved(chapter, level):
	return chapter in level_solved and level in level_solved[chapter]


func get_problem_answer(chapter, level, problem):
	if chapter in problem_answer and level in problem_answer[chapter] and problem in problem_answer[chapter][level]:
		return problem_answer[chapter][level][problem]
	else:
		return null


func get_level_fail(chapter, level):
	if chapter in level_fail and level in level_fail[chapter]:
		return level_fail[chapter][level]
	else:
		return 0


func get_level_penalty(chapter, level):
	if chapter in level_penalty and level in level_penalty[chapter]:
		return level_penalty[chapter][level]
	else:
		return 0


func save_chapter_solved(chapter):
	if chapter not in chapter_solved:
		chapter_solved.append(chapter)
	save_game()


func save_level_solved(chapter, level):
	if chapter not in level_solved:
		level_solved[chapter] = []
	if level not in level_solved[chapter]:
		level_solved[chapter].append(level)
	save_game()


func save_problem_answer(chapter, level, problem, answer):
	if chapter not in problem_answer:
		problem_answer[chapter] = {}
	if level not in problem_answer[chapter]:
		problem_answer[chapter][level] = {}
	problem_answer[chapter][level][problem] = answer
	save_game()


func save_level_fail(chapter, level, count):
	if chapter not in level_fail:
		level_fail[chapter] = {}
	level_fail[chapter][level] = count
	save_game()


func save_level_penalty(chapter, level, time):
	if chapter not in level_penalty:
		level_penalty[chapter] = {}
	level_penalty[chapter][level] = time
	save_game()


func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_line(JSON.stringify(save))
