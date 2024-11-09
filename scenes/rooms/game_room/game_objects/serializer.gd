class_name Serializer extends Object

var _object_properties:Dictionary

func _init() -> void:
	pass
func register_object(object_type:Object, property_list:Array[String]) -> void:
	_object_properties[object_type] = property_list

func go(object:Object) -> Dictionary:
	var serialize:Dictionary = {}
	var _script:Variant = object.get_script()
	if !_object_properties.has(_script): return {}
	var properties:Array = _object_properties[_script]
	
	for property:String in properties:
		var value:Variant = object.get(property)
		if value is Part:
			serialize[property] = value.to_dict()
		elif value is Object:
			serialize[property] = go(value)
		else:
			serialize[property] = value
	return serialize

func from(data:Dictionary, object:Object) -> void:
	var _script:Variant = object.get_script()
	if !_object_properties.has(_script): return
	var properties:Array = _object_properties[_script]
	for property:String in properties:
		if !data.has(property): continue
		var value:Variant = data[property]
		
		if value is Dictionary:
			var current_value:Variant = object.get(property)
			if current_value is Part:
				current_value.from_dict(value)
			elif current_value is Object:
				from(value, current_value)
		else:
			object.set(property, value)

func destroy() -> void: free()
