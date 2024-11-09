class_name GameRoom extends Room

var my_player_id:int = -1
var address:String = "192.168.0.108"
var port:int = 3115
var object_manager := ObjectManager.new(self)
var packet_manager := PacketManager.new(self)
var players:Dictionary = {}

class Player:
	var username:String
	var rank:int
	func load_userdata(userdata:Dictionary) -> void:
		if userdata.has("username"): username = userdata["username"]
		if userdata.has("rank"): rank = userdata["rank"]
	func to_userdata() -> Dictionary:
		return {
			"username":username, "rank":rank
		}
func add_player(new_player_id:int, userdata:Dictionary) -> void:
	if players.has(new_player_id): print("[!] Adding a new existing player, overriding the new player object")
	var new_player := Player.new()
	players[new_player_id] = new_player
	new_player.load_userdata(userdata)

func destroy() -> void:
	object_manager.destroy()
	packet_manager.destroy()
	for player_id:int in players:
		var player:Player = players[player_id]
		player.free()
	free()
