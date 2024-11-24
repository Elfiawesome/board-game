class_name TransitionManager extends Node

var transition_nodes:CanvasLayer

func _ready() -> void:
	load_transitions()

func load_transitions() -> void:
	resource_registry.register_resource(resource_registry.CORE_NAMESPACE, resource_registry.ResourceType.ROOM_TRANSITION, "fade", "res://scenes/room_transitions/fade.tscn")

func start_transition(
		transition_id:String,
		transition_params:Dictionary = {},
		swap_func:Callable = func() -> void: pass,
		completion_func:Callable = func() -> void: pass
	) -> void:
	if transition_id != "":
		var new_transition:RoomTransition = instantiate_transition(transition_id)
		new_transition.set_params(transition_params)
		transition_nodes.add_child(new_transition)
		new_transition.transition_swap.connect(swap_func)
		new_transition.transition_completed.connect(completion_func)
	else:
		swap_func.call()
		completion_func.call()
func instantiate_transition(transition_id: String) -> RoomTransition:
	var loaded_scene:Resource = resource_registry.get_resource(transition_id)
	if loaded_scene is PackedScene:
		var scene:RoomTransition = loaded_scene.instantiate()
		return scene
	return
