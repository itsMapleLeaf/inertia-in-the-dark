extends Node
class_name GameplayScreen

static var last_level: String

static func start(scene_tree: SceneTree, level_path: StringName):
	var gameplay_scene: PackedScene = preload("res://gameplay.tscn")
	var gameplay_screen: GameplayScreen = gameplay_scene.instantiate()
	gameplay_screen.initial_level = level_path
	last_level = level_path
	scene_tree.change_scene_to_node(gameplay_screen)

@onready var world: Node2D = %World
@onready var pause_menu: Control = %PauseMenu

var initial_level: StringName
var paused := false

func _ready() -> void:
	if initial_level:
		_load_level(initial_level)

func _load_level(level_path: StringName) -> void:
	for child in world.get_children():
		child.queue_free()

	var level_scene: PackedScene = load(level_path)
	var level_node := level_scene.instantiate()
	world.add_child(level_node)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_paused"):
		if not paused:
			_pause()
		else:
			_resume()

func _pause():
	paused = true
	world.process_mode = Node.PROCESS_MODE_DISABLED
	pause_menu.show()

func _resume():
	paused = false
	world.process_mode = Node.PROCESS_MODE_INHERIT
	pause_menu.hide()

func _on_resume_button_pressed() -> void:
	_resume()


func _on_select_level_button_pressed() -> void:
	get_tree().change_scene_to_file("res://level_select.tscn")


func _on_title_button_pressed() -> void:
	get_tree().change_scene_to_file("res://title_screen.tscn")
