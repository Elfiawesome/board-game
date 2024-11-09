class_name ObjectManager extends Object

var game_room:GameRoom
var serializer := Serializer.new()
var tile_space := TileSpaceManager.new(self)

func _init(my_game_room:GameRoom) -> void: game_room = my_game_room

func serialize() -> Dictionary: return {
		"tile_space": tile_space.serialize()
	}
func deserialize(data:Dictionary) -> void:
	tile_space.deserialize(data["tile_space"])

func destroy() -> void: 
	serializer.destroy()
	tile_space.destroy()
	free()
