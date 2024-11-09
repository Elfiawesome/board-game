class_name GameRoomClient extends GameRoom

var client: NetworkClient

func _ready() -> void:
	client = NetworkClient.new(address, port)
	client.connection_failed.connect(func(error_id: int, custom_text: String)->void:print("client connection failed ["+str(error_id)+"]: " + custom_text))
	client.connection_success.connect(func(client_id: int)->void:
		print("client connection success!")
		my_player_id = client_id
	)
	client.data_received.connect(_on_data_received)
	client.connect_to_server({"username":global.username})
	add_child(client)

func _on_data_received(data:Variant, channel:int) -> void:
	if channel==0: return
	elif channel==1: pass
	elif channel==2: packet_manager.run_packet(-1, data["id"], data["data"])

func send_data(data:Dictionary, channel:int = 2) -> void:
	client.send_data(data, channel)
