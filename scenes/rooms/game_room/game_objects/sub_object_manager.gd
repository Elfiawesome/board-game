class_name SubObjectManager extends Object

var object_manager:ObjectManager

func _init(_object_manager:ObjectManager) -> void:
	object_manager = _object_manager
	register_object()

func register_object()->void: pass

func generate_id() -> int:
	if object_manager.game_room is GameRoomServer:
		return object_manager.game_room.generate_object_id()
	else:
		return -1


func serialize() -> Dictionary: return {}
func deserialize(data:Dictionary) -> void: pass
func destroy() -> void: free()
