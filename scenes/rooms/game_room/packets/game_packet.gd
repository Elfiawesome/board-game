class_name GamePacket extends Object

var packet_name:String

func run_as_server(client_id:int, game_room:GameRoomServer, packet_data:Dictionary) -> void: pass
func run_as_client(game_room:GameRoomClient, packet_data:Dictionary) -> void: pass

func gen_server_data(game_room:GameRoomServer, params:Dictionary) -> Dictionary: return {}
func gen_client_data(game_room:GameRoomClient, params:Dictionary) -> Dictionary: return {}

func to_dict(data_params:Dictionary) -> Dictionary:
	return {"id":packet_name, "data":data_params}

func from_dict(packet_data:Dictionary) -> Dictionary:
	return packet_data["data"]
