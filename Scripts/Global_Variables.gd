extends Node

enum Chapters {
	Possibility,
	Should,
	Definition,
}

var current_chapter
var current_chapter_color

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_chapter(chapter):
	current_chapter = chapter
	match chapter:
		Chapters.Possibility:
			current_chapter_color = 0x55ff55ff
		Chapters.Should:
			current_chapter_color = 0x5555ffff
		Chapters.Definition:
			current_chapter_color = 0xffaa00ff
