extends Node

var transition_manager:TransitionManager = TransitionManager.new()

var _instance_num := -1
var _instance_socket: TCPServer
var username:String
func _ready() -> void:
	add_child(transition_manager)

func _init() -> void:
	if OS.is_debug_build():
		_instance_socket = TCPServer.new()
		for n in range(0,4):
			if _instance_socket.listen(5000 + n) == OK:
				_instance_num = n
				break
		
		assert(_instance_num >= 0, "Unable to determine instance number. Seems like all TCP ports are in use")
	
	username = "Player " + str(_instance_num)
