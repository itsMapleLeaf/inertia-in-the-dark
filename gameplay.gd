extends Node2D
class_name GameplayScreen

const LEVELS := [
	&"res://levels/straight.tscn",
	&"res://levels/turns.tscn",
	&"res://levels/snake.tscn",
	&"res://levels/split_paths.tscn",
	&"res://levels/big_curve.tscn",
	&"res://levels/obstacles.tscn",
	&"res://levels/hard_turns.tscn",
	&"res://levels/gravity_pits.tscn",
	&"res://levels/hell.tscn",
	&"res://levels/end.tscn",
]

@onready var world: Node2D = %World

@onready var pause_menu: Control = %PauseMenu
@onready var results_screen: Control = %ResultsOverlay
@onready var results_title_label: Label = %Title
@onready var next_mission_button: Button = %NextLevelButton
@onready var previous_mission_button: Button = %PreviousLevelButton
@onready var completion_time_label: Label = %CompletionTime
@onready var results_completion_time_label: Label = %FinalCompletionTime

var current_level: StringName
var player: Player
var completion_time := 0.0
var running_completion_time := false

var _paused := false

var current_level_index: int:
	get: return LEVELS.find(current_level)

var next_level: String:
	get: return LEVELS[next_level_index]

var next_level_index: int:
	get: return (current_level_index + 1) % LEVELS.size()

var previous_level: String:
	get: return LEVELS[(current_level_index - 1) % LEVELS.size()]


func _ready() -> void:
	results_screen.hide()


func load_level(level_path: StringName) -> void:
	for child in world.get_children():
		child.queue_free()

	var level_scene: PackedScene = load(level_path)
	var level_node := level_scene.instantiate()
	world.add_child(level_node)

	var new_player: Player = preload("res://player.tscn").instantiate()
	world.add_child(new_player)
	player = new_player

	player.started_moving.connect(_on_player_started_moving)
	player.killed.connect(_on_player_killed)
	player.respawned.connect(_on_player_respawned)
	player.completed_level.connect(_on_player_completed_level)

	current_level = level_path


func _reset() -> void:
	completion_time = 0
	running_completion_time = false


func _process(delta: float) -> void:
	if running_completion_time:
		completion_time += delta

	completion_time_label.text = "%.2f" % completion_time


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_paused"):
		if not _paused:
			_pause()
		else:
			_resume()


func _pause():
	_paused = true
	world.process_mode = Node.PROCESS_MODE_DISABLED
	pause_menu.show()


func _resume():
	_paused = false
	world.process_mode = Node.PROCESS_MODE_INHERIT
	pause_menu.hide()


func _show_results():
	results_title_label.text = "OBJECTIVE %s COMPLETE" % (current_level_index + 1)
	results_completion_time_label.text = "TIME: %.2f" % completion_time

	if next_level_index == 0:
		next_mission_button.text = "RETURN TO FIRST MISSION"
	else:
		next_mission_button.text = "NEXT MISSION"

	previous_mission_button.visible = current_level_index > 0

	var buttons := results_screen.find_children("", "Button", true)
	if buttons.size() > 0:
		var first_button := buttons[0]
		if first_button is Button:
			first_button.grab_focus()

	results_screen.show()

	completion_time_label.hide()


func _hide_results():
	results_screen.hide()
	completion_time_label.show()


func _on_player_started_moving() -> void:
	running_completion_time = true


func _on_player_completed_level() -> void:
	_show_results()
	running_completion_time = false


func _on_player_killed() -> void:
	running_completion_time = false


func _on_player_respawned() -> void:
	_reset()


func _on_next_pressed() -> void:
	_hide_results()
	_reset()
	load_level(next_level)


func _on_retry_pressed() -> void:
	_reset()
	player.reset()
	_hide_results.call_deferred()


func _on_previous_pressed() -> void:
	_hide_results()
	_reset()
	load_level(previous_level)


func _on_resume_button_pressed() -> void:
	_resume()


func _on_select_level_button_pressed() -> void:
	ScreenManager.pop()
	ScreenManager.push_scene(preload("res://level_select.tscn"))


func _on_title_button_pressed() -> void:
	ScreenManager.pop()
