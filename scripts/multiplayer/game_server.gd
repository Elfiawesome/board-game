class_name GameServer extends Node

var object_manager:ObjectManager
var packet_manager:PacketManager = PacketManager.new()
const address:String = "127.0.0.1"
const port:int = 3115
var my_player_id:int

class Integrated extends GameServer:
	var server:NetworkServer
	var _next_object_id:int = 0
	
	func generate_object_id() -> int:
		_next_object_id += 1
		return _next_object_id
	
	func connect_to_server() -> void:
		server = NetworkServer.new(address, port)
		server.client_requested_connection.connect(client_requested_connection)
		server.client_connected.connect(_on_client_connected)
		server.client_disconnected.connect(_on_client_disconnected)
		server.data_received.connect(_on_data_received)
		server.server_success.connect(func()->void:print("[GS-I]: Integrated Server success!"))
		server.server_failed.connect(func(error:int)->void:print("[GS-I]: Integrated Server failed. error: %s" % error))
		server.connect_to_server()
		add_child(server)
		my_player_id = server.hash_username("Server")
	func client_requested_connection(waiting_client_id:int, client_id:int, userdata:Dictionary) -> void:
		if client_id == my_player_id:
			server.reject_waiting_client(waiting_client_id, NetworkLostMsg.ERR.DUPLICATE_USERNAME)
		else:
			server.accept_waiting_client(waiting_client_id, client_id, userdata)

	func _on_client_connected(client_id:int, userdata:Dictionary) -> void:
		pass
	func _on_client_disconnected(_client_id:int, _error_id:int, _custom_text:String) -> void:
		pass
	func _on_data_received(client_id:int, data:Variant, channel:int) -> void:
		if channel==0: return
		elif channel==1:
			if is_packet_valid(data):
				var packet := packet_manager.get_packet(data["packet_name"])
				if packet != null: packet.run_as_integrated(self, client_id, data["data"])
	
	func send_data(client_id:int, data:Variant, channel:int = 1) -> void:
		server.send_data(client_id, data, channel)
	
	func broadcast_all_data(data:Variant, channel:int = 1) -> void:
		for client_id:int in server.client_datas:
			server.send_data(client_id, data, channel)
	
	func broadcast_specific_data(client_ids:Array, data:Variant, channel:int = 1) -> void:
		for client_id:int in client_ids:
			server.send_data(client_id, data, channel)
	
	func run_packet(packet_name:String, params:Dictionary = {}) -> void:
		var packet := packet_manager.get_packet(packet_name)
		if packet == null: return
		packet.run_as_integrated(self, my_player_id, params)

class Client extends GameServer:
	var client:NetworkClient
	
	func connect_to_server() -> void:
		client = NetworkClient.new(address, port)
		client.connection_failed.connect(func(error_id: int, custom_text: String)->void:print("client connection failed ["+str(error_id)+"]: " + custom_text))
		client.connection_success.connect(func(client_id: int)->void:
			my_player_id = client_id
			print("[GS-C]: client connection success! My player id is %s" % my_player_id)
		)
		client.data_received.connect(_on_data_received)
		client.connect_to_server({"username":"player %s" % global._instance_num})
		add_child(client)
	
	func _on_data_received(data:Variant, channel:int) -> void:
		if channel==0: return
		elif channel==1:
			if is_packet_valid(data):
				var packet := packet_manager.get_packet(data["packet_name"])
				if packet != null: packet.run_locally(self, 
					packet.create_payload_from_dict(data["data"])
				)
	
	func send_data(data:Variant, channel:int = 1) -> void:
		client.send_data(data, channel)
	
	func run_packet(packet_name:String, params:Dictionary = {}) -> void:
		var packet := packet_manager.get_packet(packet_name)
		if packet == null: return
		packet.run_as_client(self, params)

func _init(new_object_manager:ObjectManager) -> void:
	object_manager = new_object_manager
	packet_manager.load_packets()

func connect_to_server() -> void: pass

func run_packet(packet_name:String, params:Dictionary = {}) -> void: pass

func is_packet_valid(data:Variant) -> bool:
	if data is Dictionary:
		if data.has("packet_name") && data.has("data"):
			return true
	return false

func destroy() -> void:
	packet_manager.destroy()
	queue_free()
