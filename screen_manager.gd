extends Node

var _layer_stack: Array[CanvasLayer] = []

func push(node: Node) -> Node:
	if not _layer_stack.is_empty():
		var current_layer: CanvasLayer = _layer_stack.back()
		current_layer.hide()
		current_layer.process_mode = Node.PROCESS_MODE_DISABLED

	var new_layer := CanvasLayer.new()
	new_layer.follow_viewport_enabled = true
	_layer_stack.append(new_layer)
	add_child(new_layer)
	new_layer.add_child(node)

	return node

func push_scene(scene: PackedScene) -> Node:
	return push(scene.instantiate())

func pop():
	var removed_layer: CanvasLayer = _layer_stack.pop_back()
	if not removed_layer: return

	removed_layer.queue_free()

	var current_layer: CanvasLayer = _layer_stack.back()
	current_layer.show()
	current_layer.process_mode = Node.PROCESS_MODE_INHERIT
