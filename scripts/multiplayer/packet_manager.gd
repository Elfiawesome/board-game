class_name PacketManager extends Object

var _packets:Dictionary = {}

func load_packets() -> void:
	for resource_id:String in resource_registry.get_resources_by_type(resource_registry.ResourceType.GAME_SERVER_PACKET):
		var resource:Resource = resource_registry.get_resource(resource_id)
		if resource is GDScript:
			register_packet(resource_registry.localize_resource(resource_id), resource.new())

func register_packet(packet_name:String, packet:GameServerPacket) -> void:
	_packets[packet_name] = packet
	packet.packet_name = packet_name

func get_packet(packet_name: String) -> GameServerPacket:
	if !_packets.has(packet_name):
		push_error("[PM]: Packet not found in packet registry: %s", packet_name)
		return
	return _packets[packet_name]

func destroy() -> void:
	free.call_deferred()
