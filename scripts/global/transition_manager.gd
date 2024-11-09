class_name TransitionManager extends Node

var transition_nodes:CanvasLayer
var _transition_scenes:Dictionary = {}

enum {
	NONE = 0,
	FADE
}

func _ready() -> void:
	_transition_scenes[FADE] = load("res://scenes/room_transitions/fade.tscn")

func start_transition(
		transition_id:int,
		transition_params:Dictionary = {},
		swap_func:Callable = func() -> void: pass,
		completion_func:Callable = func() -> void: pass
	) -> void:
	if transition_id != NONE:
		var new_transition:RoomTransition = instantiate_transition(transition_id)
		new_transition.set_params(transition_params)
		transition_nodes.add_child(new_transition)
		new_transition.transition_swap.connect(swap_func)
		new_transition.transition_completed.connect(completion_func)
	else:
		swap_func.call()
		completion_func.call()
func instantiate_transition(transition_id: int) -> RoomTransition:
	if _transition_scenes.has(transition_id):
		var loaded_scene:PackedScene = _transition_scenes[transition_id]
		var scene:RoomTransition = loaded_scene.instantiate()
		return scene
	return
