class_name GameServerPacket extends Object

var packet_name:String
var _packet_payload_type:GDScript

# Default Packet.Data class
class Payload extends RefCounted:
	var params:Dictionary
	func _init(packet_parameters:Dictionary = {}) -> void:
		params = packet_parameters
	
	func to_dict() -> Dictionary:
		var result := {}
		for property in get_property_list():
			var prop_name: String = property["name"]
			if prop_name in ["Built-in script", "script", "RefCounted"]:
				continue
			result[prop_name] = get(prop_name)
		return result
	
	func from_dict(payload_data: Dictionary) -> void:
		for field: String in payload_data:
			set(field, payload_data[field])

func _init() -> void: _initialize_packet_payload_type()
func _initialize_packet_payload_type() -> void: _packet_payload_type = Payload
func create_payload_from_dict(payload_dict:Dictionary) -> Payload:
	var payload:Payload = _packet_payload_type.new()
	payload.from_dict(payload_dict)
	return payload

func run_as_integrated(game_server:GameServer.Integrated, client_id:int, params:Dictionary = {}) -> void:
	# What will be ran on the server side (such as server checks, hidden items checks)
	var payload:Payload = _packet_payload_type.new(params)
	_process_server_logic(game_server, client_id, params, payload)
	_broadcast_to_clients(game_server, client_id, params, payload)
	run_locally(game_server, payload)
func _process_server_logic(game_server:GameServer.Integrated, client_id:int, params:Dictionary, payload:Payload) -> void:
	pass
func _broadcast_to_clients(game_server:GameServer.Integrated, client_id:int, params:Dictionary, payload:Payload) -> void:
	game_server.broadcast_all_data(to_dict(payload.to_dict()))


func run_as_client(game_server:GameServer.Client, params:Dictionary = {}) -> void:
	# What will be run on both client side
	_send_client_request(game_server, params)
func _send_client_request(game_server:GameServer.Client, params:Dictionary) -> void:
	game_server.send_data(to_dict(params))


func run_locally(game_server:GameServer, payload:Payload) -> void:
	# What will be run on both client and host players
	pass


# helper functions
func to_dict(data:Dictionary) -> Dictionary: return {"packet_name":packet_name, "data":data}
func form_dict(data:Dictionary) -> Dictionary: return data["data"]
func get_object(game_server:GameServer, group_name:String, object_id:int) -> Variant:
	return game_server.object_manager.get_group(group_name).get_object(object_id)
