extends Control

@onready var level_button_template: Button = %LevelButton
@onready var level_button_grid: GridContainer = %LevelButtonGrid

func _ready() -> void:
	level_button_template.visible = true

	var level_number := 1
	for level_path in GameplayScreen.LEVELS:
		var new_level_button: Button = level_button_template.duplicate()
		new_level_button.text = "level %02d" % (level_number)
		new_level_button.pressed.connect(_level_button_pressed.bind(level_path))

		level_button_grid.add_child(new_level_button)
		level_number += 1

	level_button_template.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up")\
	or event.is_action_pressed("ui_right")\
	or event.is_action_pressed("ui_down")\
	or event.is_action_pressed("ui_left"):
		if not get_viewport().gui_get_focus_owner():
			find_next_valid_focus().grab_focus()
			get_viewport().set_input_as_handled()

func _level_button_pressed(level_path: StringName):
	ScreenManager.pop()

	# preload raises an error for strange unknown reasons
	var screen: GameplayScreen = ScreenManager.push_scene(load("res://gameplay.tscn"))
	screen.load_level(level_path)

func _on_back_button_pressed() -> void:
	ScreenManager.pop()
