extends Control

@onready var start_button: Button = %StartButton

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up")\
	or event.is_action_pressed("ui_right")\
	or event.is_action_pressed("ui_down")\
	or event.is_action_pressed("ui_left"):
		if not get_viewport().gui_get_focus_owner():
			find_next_valid_focus().grab_focus()
			get_viewport().set_input_as_handled()


func _on_start_button_pressed() -> void:
	var screen: GameplayScreen = ScreenManager.push_scene(preload("res://gameplay.tscn"))
	screen.load_level(GameplayScreen.LEVELS[0])


func _on_select_level_button_pressed() -> void:
	ScreenManager.push_scene(preload("res://level_select.tscn"))


func _on_quit_button_pressed() -> void:
	get_tree().quit()
