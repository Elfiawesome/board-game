class_name GameRoomServer extends GameRoom

var server: NetworkServer

func _ready() -> void:
	server = NetworkServer.new(address, port)
	server.client_requested_connection.connect(client_requested_connection)
	server.client_connected.connect(_on_client_connected)
	server.client_disconnected.connect(_on_client_disconnected)
	server.data_received.connect(_on_data_received)
	server.server_success.connect(func()->void:print("Server success!"))
	server.server_failed.connect(func(error:int)->void:print("Server failed. error: "+str(error)))
	server.connect_to_server()
	add_child(server)
	my_player_id = server.hash_username(global.username)
	packet_manager.run_packet_by_self("connection.player_joined")
	
	for i in 10:
		var newthing := object_manager.tile_space.create()
		newthing.position.x = randi_range(20,100)*7
		newthing.position.y = randi_range(20,100)*7


func client_requested_connection(waiting_client_id:int, client_id:int, userdata:Dictionary) -> void:
	if client_id == my_player_id:
		server.reject_waiting_client(waiting_client_id, server.ERR.DUPLICATE_USERNAME)
	else:
		server.accept_waiting_client(waiting_client_id, client_id, userdata)

func _on_client_connected(client_id:int, userdata:Dictionary) -> void:
	packet_manager.run_packet(client_id, "connection.player_joined", {"player_id":client_id, "userdata":userdata})

func _on_client_disconnected(_client_id:int, _error_id:int, _custom_text:String) -> void:
	pass

func _on_data_received(client_id:int, data:Variant, channel:int) -> void:
	if channel==0: return
	elif channel==1: pass
	elif channel==2: packet_manager.run_packet(client_id, data["id"], data["data"])


func broadcast_all_data(data:Variant, channel:int = 2) -> void:
	for client_id:int in server.client_datas:
		server.send_data(client_id, data, channel)

func broadcast_specific_data(players:Array, data:Variant, channel:int = 2) -> void:
	for client_id:int in players:
		server.send_data(client_id, data, channel)

func send_data(client_id:int, data:Variant, channel:int = 2)->void:
	server.send_data(client_id, data, channel)

var next_id:int = 0
func generate_object_id() -> int:
	next_id += 1
	return next_id
