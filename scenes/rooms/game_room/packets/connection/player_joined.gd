extends GamePacket

func run_as_server(client_id:int, game_room:GameRoomServer, packet_data:Dictionary) -> void:
	var player_id:int = packet_data["player_id"]
	if client_id != player_id: return
	game_room.add_player(
		packet_data["player_id"],
		packet_data["userdata"],
	)
	
	var client_ids := game_room.server.get_clients()
	if client_ids.has(player_id): client_ids.erase(player_id)
	var new_player:GameRoom.Player = game_room.players[player_id]
	game_room.broadcast_specific_data(
		client_ids,
		to_dict({
			"new_players":{
				player_id: new_player.to_userdata()
			}
		})
	)
	
	var new_players_data:Dictionary
	for _player_id:int in game_room.players: new_players_data[_player_id] = game_room.players[_player_id].to_userdata()
	game_room.send_data(client_id, to_dict({
		"new_players":new_players_data,
		"objects": game_room.object_manager.serialize()
	}))

func run_as_client(game_room:GameRoomClient, packet_data:Dictionary) -> void:
	for player_id:int in packet_data["new_players"]:
		var new_player_data:Dictionary = packet_data["new_players"][player_id]
		game_room.add_player(player_id, new_player_data)
	if packet_data.has("objects"): game_room.object_manager.deserialize(packet_data["objects"])
func gen_server_data(game_room:GameRoomServer, params:Dictionary) -> Dictionary:
	return {
		"player_id":game_room.my_player_id,
		"userdata": {"username":global.username}
	}
func gen_client_data(game_room:GameRoomClient, params:Dictionary) -> Dictionary: return {}
