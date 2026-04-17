extends Control


func _on_start_button_pressed() -> void:
	GameplayScreen.start(get_tree(), LevelManager.levels[0])


func _on_select_level_button_pressed() -> void:
	get_tree().change_scene_to_file("res://level_select.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
