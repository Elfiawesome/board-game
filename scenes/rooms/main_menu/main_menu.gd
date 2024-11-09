extends Room

func _ready() -> void:
	if global._instance_num == 0:
		room_manager.change_room(room_manager.ROOM_ID.GAME_ROOM_SERVER,global.transition_manager.FADE, {"color":Color.GREEN}, 
			func(room:Room)->void:
				if room is GameRoom:
					print("SERVER")
		)
	else:
		room_manager.change_room(room_manager.ROOM_ID.GAME_ROOM_CLIENT,global.transition_manager.FADE, {"color":Color.GREEN}, 
			func(room:Room)->void:
				if room is GameRoom:
					print("CLIENT: "+str(global._instance_num))
		)
