class_name PacketManager extends Object

var game_room:GameRoom
var packets:Dictionary

func _init(my_game_room:GameRoom) -> void:
	game_room = my_game_room
	register_all_packet_in_folder("res://scenes/rooms/game_room/packets/", [])

func register_all_packet_in_folder(folder_path:String, base_group:Array[String]) -> void:
	for path in DirAccess.get_directories_at(folder_path):
		var new_base_group := base_group.duplicate()
		new_base_group.push_back(path)
		register_all_packet_in_folder(folder_path+"/"+path, new_base_group)
	for path in DirAccess.get_files_at(folder_path):
		var packet_name:String
		for group in base_group:
			packet_name += group+"."
		packet_name += path.split(".")[0]
		register_packet(packet_name, load(folder_path+"/"+path).new())

func register_packet(packet_name:String, packet:GamePacket) -> void:
	packets[packet_name] = packet
	packet.packet_name = packet_name

func run_packet(client_id:int, packet_name:String, packet_data:Dictionary) -> void:
	if !packets.has(packet_name): 
		print("Can't run & find packet with name ["+packet_name+"]: ["+str(packet_data)+"]")
		return
	var packet:GamePacket = packets[packet_name]
	if game_room is GameRoomServer: packet.run_as_server(client_id, game_room, packet_data)
	if game_room is GameRoomClient: packet.run_as_client(game_room, packet_data)

func run_packet_by_self(packet_name:String, params:Dictionary = {}) -> void:
	if !packets.has(packet_name):
		print("Can't run & find packet with name ["+packet_name+"]: gen-params["+str(params)+"]")
		return
	var packet:GamePacket = packets[packet_name]
	if game_room is GameRoomServer: packet.run_as_server(game_room.my_player_id, game_room, packet.gen_server_data(game_room, params))
	if game_room is GameRoomClient: packet.run_as_client(game_room, packet.gen_client_data(game_room, params))

func destroy() -> void:
	for packet_name:String in packets:
		var packet:GamePacket = packets[packet_name]
		packet.free()
	free()
