extends Node

# Dictionary to store all registered resources by their namespaced ID
# Format: {"namespace:resource_type/resource_id": Resource}
var _registry: Dictionary = {}

# Signal emitted when a new resource is registered
signal resource_registered(name_space: String, type: String, id: String, resource: Resource)

# Constants for built-in namespaces
const CORE_NAMESPACE := "core"
const MOD_NAMESPACE := "mod"

# Enum for different resource types
enum ResourceType {
	ROOM,
	ROOM_TRANSITION,
	GAME_OBJECT,
	GAME_OBJECT_MANAGER_GROUP,
	GAME_SERVER_PACKET,
}

# Convert ResourceType enum to string
func get_type_string(type: ResourceType) -> String:
	match type:
		ResourceType.ROOM: return "room"
		ResourceType.ROOM_TRANSITION: return "room_transition"
		ResourceType.GAME_OBJECT: return "game_object"
		ResourceType.GAME_OBJECT_MANAGER_GROUP: return "game_object_manager_group"
		ResourceType.GAME_SERVER_PACKET: return "game_server_packet"
		_: return "unknown"

# Register a resource with a namespaced ID
func register_resource(name_space: String, type: ResourceType, id: String, resource_path: String) -> void:
	var type_str := get_type_string(type)
	var full_id := "%s:%s/%s" % [name_space, type_str, id]
	
	if _registry.has(full_id):
		push_warning("[RR]: Resource already registered with ID: %s" % full_id)
		return
	
	var resource:Resource = load(resource_path)
	_registry[full_id] = resource
	resource_registered.emit(name_space, type_str, id, resource)

# Get a resource by its namespaced  and ID
func get_resource_id(name_space: String, type: ResourceType, id: String) -> String:
	var type_str := get_type_string(type)
	return "%s:%s/%s" % [name_space, type_str, id]

func get_local_resource_id(name_space: String, id: String) -> String:
	return "%s:%s" % [name_space, id]

# Get resource by full ID
func get_resource(full_id: String) -> Resource:
	if not _registry.has(full_id):
		push_error("[RR]: Resource not found: %s" % full_id)
		return null
	return _registry[full_id]

func split_resource_id(full_id: String) -> Array[String]:
	var _1s := full_id.split(":")
	var _2s := _1s[1].split("/")
	return [_1s[0], _2s[0], _2s[1]]

func localize_resource(full_id: String) -> String:
	var _s := split_resource_id(full_id)
	return get_local_resource_id(_s[0], _s[2])

# Get all resources of a specific type
func get_resources_by_type(type: ResourceType) -> Array[String]:
	var type_str := get_type_string(type)
	var resources:Array[String] = []
	for key:String in _registry:
		if key.split(":")[1].begins_with(type_str):
			resources.append(key)
	return resources


# Get all resources from a specific namespace
func get_resources_by_namespace(name_space: String) -> Array[String]:
	var resources:Array[String] = []
	for key:String in _registry:
		if key.split(":")[0] == name_space:
			resources.append(key)
	return resources

# Clear all resources from a specific namespace
func clear_namespace(name_space: String) -> void:
	var keys_to_remove := get_resources_by_namespace(name_space)
	for key in keys_to_remove:
		_registry.erase(key)

# Clear all resources from a specific type
func clear_types(type: resource_registry.ResourceType) -> void:
	var keys_to_remove := get_resources_by_type(type)
	for key in keys_to_remove:
		_registry.erase(key)


# Check if a resource exists
func has_resource(name_space: String, type: ResourceType, id: String) -> bool:
	var type_str := get_type_string(type)
	var full_id := "%s:%s/%s" % [name_space, type_str, id]
	return _registry.has(full_id)
