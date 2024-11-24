class_name ObjectManager extends Object

var root_node:Node
var serializer:Serializer = Serializer.new()
var _groups:Dictionary

class Group extends Object:
	var name:String
	func destroy() -> void: free.call_deferred()
	func _init(serializer:Serializer) -> void: pass
	func get_object(object_id: int) -> Object: return
	func remove(object_id: int) -> void: pass
	func add(object_id: int) -> void: pass
	func to_dict() -> void: pass
	func from_dict(data:Dictionary) -> void: pass

func _init(set_root_node:Node) -> void:
	root_node = set_root_node

func load_groups() -> void:
	for resource_id:String in resource_registry.get_resources_by_type(resource_registry.ResourceType.GAME_OBJECT_MANAGER_GROUP):
		var resource:Resource = resource_registry.get_resource(resource_id)
		if resource is GDScript:
			_groups[resource_registry.localize_resource(resource_id)] = resource.new(serializer)

func register_group(group_name:String, group:Group) -> void:
	_groups[group_name] = group
	group.name = group_name

func get_group(group_name: String) -> Group:
	if !_groups.has(group_name):
		push_error("[OM]: Group not found in group registry: %s", group_name)
		return
	return _groups[group_name]

func destroy() -> void:
	for group_name:String in _groups:
		var group:Group = _groups[group_name]
		group.destroy()
	serializer.destroy()
	free.call_deferred()
