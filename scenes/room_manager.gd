class_name RoomManager extends Control
@export var room_nodes:Control
@export var transition_nodes:CanvasLayer

var current_room:Room

func _ready() -> void:
	global.transition_manager.transition_nodes = transition_nodes
	
	resource_registry.register_resource(resource_registry.CORE_NAMESPACE, resource_registry.ResourceType.ROOM, "main_menu", "res://scenes/rooms/main_menu/main_menu.tscn")
	resource_registry.register_resource(resource_registry.CORE_NAMESPACE, resource_registry.ResourceType.ROOM, "game_session", "res://scenes/rooms/game_session/game_session.tscn")
	change_room(
		resource_registry.get_resource_id(resource_registry.CORE_NAMESPACE, resource_registry.ResourceType.ROOM, "game_session"),
		resource_registry.get_resource_id(resource_registry.CORE_NAMESPACE, resource_registry.ResourceType.ROOM_TRANSITION, "fade"),
		{"color":Color.WHITE}
	)

func change_room(room_id: String, transition_id: String = "", transition_params: Dictionary = {}, completion_lamda: Callable = func(_room: Room) -> void: pass) -> void:
	var new_room:Room = instantiate_room(room_id)
	global.transition_manager.start_transition(
		transition_id, transition_params,
		func() -> void:
			if current_room:
				current_room.queue_free()
			room_nodes.add_child(new_room)
			current_room = new_room
			completion_lamda.call(current_room),
		func() -> void: new_room.room_ready()
	)

func instantiate_room(room_id:String) -> Room:
	var loaded_scene:PackedScene = resource_registry.get_resource(room_id)
	if loaded_scene == null: return null
	var scene:Room = loaded_scene.instantiate()
	scene.room_manager = self
	return scene
