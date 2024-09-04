extends Node3D
## Gameplay manager
## Made by Yni, licensed under MIT license.
class_name FacilityManager

## Nickname
var local_nickname: String
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var env: WorldEnvironment
## Path to world environment
@export var environment_path: String
## Level data (contains list of all classes, items, e.t.c)
@export var game_data: GameData
## Level main music
@export var music_to_play: Array[String] = []
## Max spawnable objects (set by NetworkManager)
@export var max_spawnable_objects: int = 12
## Round start check.
@export var is_round_started: bool
## Player scene, that will become a player afterwards
@export var player_prefab: PackedScene
## List of the players
@export var players_list: Array[int] = []
# Player tickets
#@export var tickets: Array[int] = []
## Ambient file path, used by Music Changer function
var current_ambient: String

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().root.get_node("Main/LoadingScreen/").visible = false
	env = get_node("WorldEnvironment")
	## Load graphics
	if env.environment == null || environment_path.is_empty():
		env.environment = load("res://DefaultGraphics.tres")
	else:
		env.environment = load(environment_path)
	## Set user settings
	env.environment.sdfgi_enabled = Settings.setting_res.dynamic_gi
	env.environment.ssao_enabled = Settings.setting_res.ssao
	env.environment.ssil_enabled = Settings.setting_res.ssil
	env.environment.ssr_enabled = Settings.setting_res.ssr
	env.environment.glow_enabled = Settings.setting_res.glow
	## Set background music through music ID.
	if music_to_play.size() > 0:
		set_background_music(music_to_play[0])
	on_start()
	if multiplayer.is_server():
		## Server methods
		max_spawnable_objects = get_parent().max_objects
		multiplayer.peer_connected.connect(add_player)
		multiplayer.peer_disconnected.connect(remove_player)
		## Add players
		for id in multiplayer.get_peers():
			add_player(id)
		add_player(1)
		
		on_server_start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	on_update(delta)

func on_start():
	pass

func on_server_start():
	begin_game()

func on_update(delta: float):
	pass

## Unnecessary. Example implementation of round start. Adds the players in the list and set to human class.
func begin_game():
	var players: Array[Node] = get_tree().get_nodes_in_group("Players")
	var i: int = 1
	is_round_started = true
	for player in players:
		if player is PlayerScript:
			rpc_id(player.name.to_int(), "set_player_class", str(player.name), 1, "Round start", false)
			i += 1

## Adds player to server.
func add_player(id: int):
	## Player scene, that will become a player afterwards
	var player_scene: CharacterBody3D
	player_scene = player_prefab.instantiate()
	player_scene.name = str(id)
	add_child(player_scene, true)
	players_list.append(player_scene.name.to_int())
	if is_round_started:
		post_round_start(players_list, id)
	print("Player " + str(id) + " has joined the server!")


## Removes the player from server
func remove_player(id: int):
	if get_node_or_null(str(id)) != null:
		get_node(str(id)).queue_free()
		players_list.erase(str(id))
		print("Player " + str(id) + " has left the server!")


## Sets player class for a specified player. (RpcId)
@rpc("any_peer", "call_local")
func set_player_class(player_name: String, name_of_class: int, reason: String, post_start: bool):
	if name_of_class < 0 || name_of_class >= game_data.classes.size():
		print("For security reasons, you cannot change to class, that is unsupported by this server")
	var class_data: BaseClass = game_data.classes[name_of_class]
	if !post_start:
		rpc("set_player_class_public", player_name, name_of_class)
	get_node(player_name).player_class_key = name_of_class
	get_node(player_name).player_class_description = class_data.player_class_description
	get_node(player_name).sprint_enabled = class_data.sprint_enabled
	get_node(player_name).speed = class_data.speed
	get_node(player_name).jump = class_data.jump
	get_node(player_name).can_move = class_data.can_move
	# get_node(player_name).enable_inventory = class_data.enable_inventory
	get_node(player_name).call("camera_manager", !class_data.custom_camera)
	get_node(player_name).call("update_class_ui", class_data.class_color.to_rgba32())
	get_node(player_name).call("apply_shader", class_data.custom_shader)
	# call("preload_inventory")
	var spawn_point: String = class_data.spawn_points[rng.randi_range(0, class_data.spawn_points.size() - 1)]
	if get_tree().root.get_node_or_null(spawn_point) != null:
		get_node(player_name).global_position = get_tree().root.get_node(spawn_point).global_position


## Sets player class through the RPC.
@rpc("any_peer", "call_local")
func set_player_class_public(player_name: String, name_of_class: int):
	var class_data: BaseClass = game_data.classes[name_of_class]
	get_node(player_name).player_class_name = class_data.player_class_name
	get_node(player_name).move_sounds_enabled = class_data.move_sounds_enabled
	get_node(player_name).unique_type_id = class_data.unique_type_id
	get_node(player_name).footstep_sounds = class_data.footstep_sounds
	get_node(player_name).sprint_sounds = class_data.sprint_sounds
	get_node(player_name).health = class_data.health
	get_node(player_name).current_health = class_data.health.duplicate()
	get_node(player_name).ragdoll_source = class_data.player_ragdoll_source
	load_models(player_name, name_of_class)

## Recall player classes for player, which got connected to ongoing round.
func post_round_start(players, target):
	rpc_id(target, "set_player_class", str(multiplayer.get_unique_id()), 0, "Post-roundstart arrival", false)
	for player in players:
		if str(player) != str(multiplayer.get_unique_id()):
			rpc_id(target, "set_player_class", str(player), get_node(str(player)).player_class_key, "Previous player", true)
	#rpc("clean_ragdolls")

## Loads the models of a player.
func load_models(player_name: String, class_id: int):
	var player = get_node(player_name)
	if class_id >= 0 && class_id < game_data.classes.size():
		var model_root: Node = player.get_node("PlayerModel")
		for item_used_before in model_root.get_children():
			item_used_before.queue_free()
		var tmp_model: Node3D = load(game_data.classes[class_id].player_model_source).instantiate()
		model_root.add_child(tmp_model)

## Spawns player ragdoll.
@rpc("any_peer", "call_local")
func spawn_ragdoll(player: String, ragdoll_src: String):
	pass
## Cleans ragdolls (used when a new player connects)
@rpc("any_peer", "call_local")
func clear_ragdolls():
	for node in get_node("Ragdolls").get_children():
		node.queue_free()
## Teleports object to player.
@rpc("any_peer", "call_local")
func teleport_to(from: String, destination: String):
	match destination:
		"random_player":
			get_node(from).global_position = get_node(str(players_list[rng.randi_range(0, players_list.size() - 1)])).global_position
		_:
			get_node(from).global_position = get_node(destination).global_position
## Sets background music.
func set_background_music(to: String):
	if current_ambient != to:
		$AnimationPlayer.play("music_change")
		$BackgroundMusic.stream = load(to)
		$BackgroundMusic.playing = true
		$AnimationPlayer.play_backwards("music_change")
		current_ambient = to
