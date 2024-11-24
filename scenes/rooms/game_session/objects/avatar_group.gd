extends ObjectManager.Group

func _init(serializer:Serializer) -> void:
	serializer.register_object(resource_registry.get_resource(resource_registry.get_resource_id(resource_registry.CORE_NAMESPACE, resource_registry.ResourceType.GAME_OBJECT, "avatar")), [
		
	])
