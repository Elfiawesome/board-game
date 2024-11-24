class_name GameSession extends Room
# https://gitmoji.dev/
var game_server:GameServer
var object_manager:ObjectManager = ObjectManager.new(self)

func _init() -> void:
	# register all related game objects
	# register all game objects & groups
	resource_registry.register_resource(resource_registry.CORE_NAMESPACE, resource_registry.ResourceType.GAME_OBJECT, "avatar", "res://scenes/rooms/game_session/objects/avatar.gd")
	resource_registry.register_resource(resource_registry.CORE_NAMESPACE, resource_registry.ResourceType.GAME_OBJECT_MANAGER_GROUP, "avatar", "res://scenes/rooms/game_session/objects/avatar_group.gd")
	# register all packets
	resource_registry.register_resource(resource_registry.CORE_NAMESPACE, resource_registry.ResourceType.GAME_SERVER_PACKET, "example_packet", "res://scenes/rooms/game_session/packets/example_packet.gd")
	
	# load all game objects into object_manager
	object_manager.load_groups()
	# Initialize game_server
	if global._instance_num == 0:
		game_server = GameServer.Integrated.new(object_manager)
	else:
		game_server = GameServer.Client.new(object_manager)
	add_child(game_server)
	game_server.connect_to_server()


# When we leave the game session, we unregistered related game objects
func shutdown() -> void:
	game_server.destroy()
	object_manager.destroy()
	resource_registry.clear_types(resource_registry.ResourceType.GAME_OBJECT)
	resource_registry.clear_types(resource_registry.ResourceType.GAME_OBJECT_MANAGER_GROUP)
	resource_registry.clear_types(resource_registry.ResourceType.GAME_SERVER_PACKET)
