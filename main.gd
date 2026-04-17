extends Node

func _ready() -> void:
	ScreenManager.push_scene(preload("res://title_screen.tscn"))
