extends Control


func _on_start_button_pressed() -> void:
	var screen: GameplayScreen = ScreenManager.push_scene(preload("res://gameplay.tscn"))
	screen.load_level(GameplayScreen.LEVELS[0])


func _on_select_level_button_pressed() -> void:
	ScreenManager.push_scene(preload("res://level_select.tscn"))


func _on_quit_button_pressed() -> void:
	get_tree().quit()
