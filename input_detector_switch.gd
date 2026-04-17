extends Node
class_name InputDetectorSwitch

@export var keyboard_node: Node
@export var gamepad_node: Node

func _ready() -> void:
	keyboard_node.visible = InputDetector.current_input_type == InputDetector.InputType.KEYBOARD
	gamepad_node.visible = InputDetector.current_input_type == InputDetector.InputType.GAMEPAD

	InputDetector.input_type_changed.connect(_on_input_type_changed)

func _on_input_type_changed(input_type: InputDetector.InputType) -> void:
	keyboard_node.visible = input_type == InputDetector.InputType.KEYBOARD
	gamepad_node.visible = input_type == InputDetector.InputType.GAMEPAD
