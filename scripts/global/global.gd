extends Node

var transition_manager:TransitionManager = TransitionManager.new()

var _instance_num := -1
var _instance_socket: TCPServer

func _ready() -> void:
	add_child(transition_manager)
	get_window().size = DisplayServer.screen_get_size()/2
	get_window().title = str(_instance_num)
	if global._instance_num == 0: get_window().position = Vector2(0,0)
	if global._instance_num == 1: get_window().position = Vector2(DisplayServer.screen_get_size().x/2,0)
	if global._instance_num == 2: get_window().position = Vector2(0,DisplayServer.screen_get_size().y/2)
	if global._instance_num == 3: get_window().position = DisplayServer.screen_get_size()/2

func _init() -> void:
	if OS.is_debug_build():
		_instance_socket = TCPServer.new()
		for n in range(0,4):
			if _instance_socket.listen(5000 + n) == OK:
				_instance_num = n
				break
		
		assert(_instance_num >= 0, "Unable to determine instance number. Seems like all TCP ports are in use")
