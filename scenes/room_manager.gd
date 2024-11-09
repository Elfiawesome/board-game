class_name RoomManager extends Control
@export var room_nodes:Control
@export var transition_nodes:CanvasLayer

enum ROOM_ID {
	MAIN_MENU,
	GAME_ROOM,
	GAME_ROOM_SERVER,
	GAME_ROOM_CLIENT,
}
var _room_scenes:Dictionary = {}
var current_room:Room

func _ready() -> void:
	global.transition_manager.transition_nodes = transition_nodes
	# Register rooms here
	_room_scenes[ROOM_ID.MAIN_MENU] = load("res://scenes/rooms/main_menu/main_menu.tscn")
	_room_scenes[ROOM_ID.GAME_ROOM_SERVER] = load("res://scenes/rooms/game_room/game_room_server.tscn")
	_room_scenes[ROOM_ID.GAME_ROOM_CLIENT] = load("res://scenes/rooms/game_room/game_room_client.tscn")
	change_room(ROOM_ID.MAIN_MENU, global.transition_manager.FADE)

func change_room(room_id: int, transition_id:int = TransitionManager.NONE, transition_params:Dictionary = {}, completion_lamda: Callable = func(_room: Room) -> void:pass) -> void:
	var new_room:Room = instantiate_room(room_id)
	global.transition_manager.start_transition(
		transition_id, {},
		func() -> void:
			if current_room:
				current_room.queue_free()
			room_nodes.add_child(new_room)
			current_room = new_room
			completion_lamda.call(current_room)
	)

func instantiate_room(room_id: int) -> Room:
	if _room_scenes.has(room_id):
		var loaded_scene:PackedScene = _room_scenes[room_id]
		var scene:Room = loaded_scene.instantiate()
		scene.room_manager = self
		return scene
	return
