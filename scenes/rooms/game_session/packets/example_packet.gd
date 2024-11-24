extends GameServerPacket

func run_locally(game_server:GameServer, payload:Payload) -> void:
	# What will be run on both client and host players
	print("Received msg: ["+payload.params["msg"]+"]")
