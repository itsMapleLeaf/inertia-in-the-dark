extends Node
class_name InputPressedToggle

@export_custom(PROPERTY_HINT_INPUT_NAME, "input_action") var input_action: StringName
@export var released_node: Control
@export var pressed_node: Control

func _ready() -> void:
	pressed_node.visible = Input.is_action_pressed(input_action)
	released_node.visible = not Input.is_action_pressed(input_action)

func _input(event: InputEvent) -> void:
	if event.is_action(input_action):
		pressed_node.visible = event.is_pressed()
		released_node.visible = event.is_released()
