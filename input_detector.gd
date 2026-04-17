extends Node

enum InputType {
	KEYBOARD,
	GAMEPAD,
}

signal input_type_changed(type: InputType)

var current_input_type: InputType = InputType.KEYBOARD:
	set(new_input_type):
		current_input_type = new_input_type
		input_type_changed.emit(new_input_type)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		current_input_type = InputType.KEYBOARD
	elif event is InputEventJoypadButton \
	or (event is InputEventJoypadMotion and absf(event.axis_value) >= 0.5):
		current_input_type = InputType.GAMEPAD
