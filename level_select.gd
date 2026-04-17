extends Control

@onready var level_button_template: Button = %LevelButton
@onready var level_button_grid: GridContainer = %LevelButtonGrid


func _ready() -> void:
	level_button_template.visible = true

	var level_number := 1
	for level_path in LevelManager.levels:
		var new_level_button: Button = level_button_template.duplicate()
		new_level_button.text = "level %02d" % (level_number)

		new_level_button.pressed.connect(func():
			get_tree().change_scene_to_file(level_path)
		)

		level_button_grid.add_child(new_level_button)
		level_number += 1

	level_button_template.visible = false


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://title_screen.tscn")
