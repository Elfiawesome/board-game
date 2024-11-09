class_name TileSpaceManager extends SubObjectManager

var packed_scene:PackedScene = load("res://scenes/rooms/game_room/game_objects/tile_space.tscn")
var tile_spaces:Dictionary

func register_object() -> void:
	object_manager.serializer.register_object(TileSpace, ["position","scale","rotation"])

func create(tile_space_id:int = generate_id()) -> TileSpace:
	var new_tile_space:TileSpace = packed_scene.instantiate()
	tile_spaces[tile_space_id] = new_tile_space
	object_manager.game_room.add_child(new_tile_space)
	return new_tile_space

func serialize() -> Dictionary: 
	var data:Dictionary = {}
	for tile_space_id:int in tile_spaces:
		var tile_space:TileSpace = tile_spaces[tile_space_id]
		data[tile_space_id] = object_manager.serializer.go(tile_space)
	return data
func deserialize(data:Dictionary) -> void:
	var tile_spaces_keys:Array = tile_spaces.keys()
	var data_tile_spaces_keys:Array = data.keys()
	
	for tile_space_id:int in tile_spaces_keys:
		if !data_tile_spaces_keys.has(tile_space_id):
			tile_spaces[tile_space_id].queue_free()
			tile_spaces.erase(tile_space_id)
	for tile_space_id:int in data_tile_spaces_keys:
		var tile_space:TileSpace
		if tile_spaces.has(tile_space_id):
			# Update existing tile space
			tile_space = tile_spaces[tile_space_id]
		else:
			# Create new tile space
			tile_space = create(tile_space_id)
			
		object_manager.serializer.from(data[tile_space_id], tile_space)
