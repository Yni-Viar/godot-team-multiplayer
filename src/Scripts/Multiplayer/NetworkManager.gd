extends Node
## Network Manager. Should be placed in /root/Main/ in node tree.
## Made by Yni, licensed under MIT license.
class_name NetworkManager

## Server's IP address
static var ip_address: String
## Server's port (used for connections)
static var port: int
## Player limit on server
static var max_players: int
## gamemode name (unnecessary)
var game_mode: String
## npc spawn (unnecessary)
var spawn_npcs: bool
## max objects (unnecessary)
var max_objects: int
## Need for networking
var peer: ENetMultiplayerPeer
## Scene file path
var scene_to_load: String = "res://Scenes/Game.tscn"
## need for loading screen
var loading: bool = false
## Config
var config_values: Array[String] = ["Port", "MaxPlayers", "MaxSpawnableObjects", "GameMode"]
## Config
var config_defaults: Array = [7877, 20, 12, "Default"]

func _enter_tree():
	set_data()
	#var txt: TxtParser = TxtParser.new()
	#
	#if !FileAccess.file_exists("user://modlist_" + Globals.data_compatibility + ".txt"):
		#txt.save("user://modlist_" + Globals.data_compatibility + ".txt", "Default")

# Called when the node enters the scene tree for the first time.
#func _ready():
	#if DisplayServer.get_name() == "headless":
		#Host()
	#pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if loading:
		var progress: Array
		var status = ResourceLoader.load_threaded_get_status(scene_to_load, progress)
		match status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				get_tree().root.get_node("Main/LoadingScreen/MainPanel/ProgressBar").value = progress[0] * 100
			ResourceLoader.THREAD_LOAD_LOADED:
				get_tree().root.get_node("Main/LoadingScreen/MainPanel/ProgressBar").value = 100
				prepare_level(ResourceLoader.load_threaded_get(scene_to_load))
			ResourceLoader.THREAD_LOAD_FAILED:
				printerr("Could not load...")
## General host method.
func host():
	peer = ENetMultiplayerPeer.new()
	peer.create_server(port, max_players)
	multiplayer.multiplayer_peer = peer
	load_game(scene_to_load)
	get_tree().root.get_node("Main/CanvasLayer/MainMenu").hide()
## General join method.
func join():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, port)
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	multiplayer.server_disconnected.connect(server_disconnected)
	get_tree().root.get_node("Main/CanvasLayer/MainMenu").hide()

## Loads the game server-side.
## NOT to be confused with LoadLevel, LoadGame is a serverside function, while LoadLevel - clientside.
## Both needed to spawn a level to every player via Multiplayer Spawner.
func load_game(path: String):
	if multiplayer.is_server():
		call_deferred("load_level", path)

## First part of client-side loading
func load_level(path: String):
	get_tree().root.get_node("Main/LoadingScreen/").visible = true
	ResourceLoader.load_threaded_request(path)
	loading = true

## First part of client-side loading
func prepare_level(scene: PackedScene):
	if get_node_or_null("Game") != null:
		for node in get_node("Game").get_children():
			get_node("Game").remove_child(node)
			node.queue_free()
		get_node("Game").queue_free()
	loading = false
	add_child(scene.instantiate(), true)
	get_tree().root.get_node("Main/LoadingScreen/").visible = false

## Emitted when successfully connected to server.
func connected_to_server():
	rpc_id(1, "get_version", Settings.DATA_COMPATIBILITY)
	print("Connected to the server!")

## Emitted when connection is failed.
func connection_failed():
	multiplayer.multiplayer_peer = null
	peer.close()
	print("Connection Failed!")
	get_tree().root.get_node("Main/CanvasLayer/MainMenu").show()
	get_node("CanvasLayer/MainMenu/AudioStreamPlayer").playing = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

## Emitted when server is disconnected.
func server_disconnected():
	get_node("CanvasLayer/InGameConsole").hide()
	multiplayer.multiplayer_peer = null
	peer.close()
	if get_node_or_null("Game") != null:
		get_node("Game").queue_free()
	loading = false
	print("You are disconnected from the server.")
	get_tree().root.get_node("Main/CanvasLayer/MainMenu").show()
	get_node("CanvasLayer/MainMenu/AudioStreamPlayer").playing = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

## Gets player's IP-address. PLEASE, CHECK CONSOLE FOR UNAUTHORIZED ACCESS
func get_peer(id: int):
	print("SECURITY WARNING!!! SOMEONE GOT IP-ADDRESS")
	return peer.get_peer(id).get_remote_address()

## Kicks a player. PLEASE, CHECK CONSOLE FOR UNAUTHORIZED ACCESS
@rpc("any_peer")
func kick():
	print("SECURITY WARNING!!! SOMEONE TRIED TO KICK A PLAYER")
	server_disconnected()

## Checks, if the version of client and server is equal.
@rpc("any_peer")
func get_version(compatible_version: String):
	if compatible_version != Settings.DATA_COMPATIBILITY:
		rpc_id(multiplayer.get_remote_sender_id(), "kick")
## Sets server config.
func set_data():
	var config: IniParser = IniParser.new()
	if FileAccess.file_exists("user://serverconfig_" + Settings.DATA_COMPATIBILITY + ".ini"):
		port = int(config.load_ini("user://serverconfig_" + Settings.DATA_COMPATIBILITY + ".ini", "ServerConfig", config_values)[0])
		max_players = int(config.load_ini("user://serverconfig_" + Settings.DATA_COMPATIBILITY + ".ini", "ServerConfig", config_values)[1])
		max_objects = int(config.load_ini("user://serverconfig_" + Settings.DATA_COMPATIBILITY + ".ini", "ServerConfig", config_values)[2])
		game_mode = config.load_ini("user://serverconfig_" + Settings.DATA_COMPATIBILITY + ".ini", "ServerConfig", config_values)[3]
	else:
		config.save_ini("ServerConfig", config_values, config_defaults, "user://serverconfig_" + Settings.DATA_COMPATIBILITY + ".ini")
		port = int(config.load_ini("user://serverconfig_" + Settings.DATA_COMPATIBILITY + ".ini", "ServerConfig", config_values)[0])
		max_players = int(config.load_ini("user://serverconfig_" + Settings.DATA_COMPATIBILITY + ".ini", "ServerConfig", config_values)[1])
		max_objects = int(config.load_ini("user://serverconfig_" + Settings.DATA_COMPATIBILITY + ".ini", "ServerConfig", config_values)[2])
		game_mode = config.load_ini("user://serverconfig_" + Settings.DATA_COMPATIBILITY + ".ini", "ServerConfig", config_values)[3]
## Gets gamemode
#func get_gamemode() -> String:
	#return "res://Scenes/Game.tscn"
