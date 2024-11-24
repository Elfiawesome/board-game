class_name Serializer extends Object

var _object_properties:Dictionary = {}

func register_object(object_type:Resource, properties_list:Array[String] = []) -> void:
	_object_properties[object_type] = properties_list

func to(object:Object) -> Dictionary:
	var object_script:Resource = object.get_script()
	if !_object_properties.has(object_script): return {}
	var properties:Array[String] = _object_properties[object_script]
	var serialize:Dictionary = {}
	
	for property:String in properties:
		var value:Variant = object.get(property)
		if value is Object:
			serialize[property] = to(value)
		else:
			serialize[property] = value
	return serialize

func from(object:Object, data:Dictionary) -> void:
	var object_script:Resource = object.get_script()
	if !_object_properties.has(object_script): return
	var properties:Array[String] = _object_properties[object.get_script()]
	for property:String in properties:
		var value:Variant = data[property]
		if (value is Dictionary) && (object.get(property) is Object):
			var property_object:Object = object.get(property)
			from(property_object, value)
		else:
			object.set(property, value)

func destroy() -> void:free.call_deferred()
