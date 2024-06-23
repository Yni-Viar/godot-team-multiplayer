extends Node
## Commands for GDSh

# Called when the node enters the scene tree for the first time.
func _ready():
	GDsh.add_command("forceclass", forceclass, "Forceclass to player", "Changes player class to a given player, requires number.")
	GDsh.add_command("classlist", class_list, "Returns all class names and it's ids")
	GDsh.add_command("givehp", set_health, "Adds or depletes health values")
	GDsh.add_command("give", give, "Gives an item to you.")
	GDsh.add_command("give_item", give_item, "Gives an item into inventory")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func forceclass(args: Array):
	if args.size() == 1 && str(args[0]).is_valid_int():
		if int(args[0]) < get_tree().root.get_node("Main/Game/").game_data.classes.size() && int(args[0]) >= 0:
			get_tree().root.get_node("Main/Game").rpc_id(multiplayer.get_unique_id(), "set_player_class", str(multiplayer.get_unique_id()), int(args[0]), "Forced class change", false)
			return "Successfully forceclassed to a class with id " + args[0]
		else:
			return "Wrong number. Try different number, for example 0"
	else:
		return "You need ONLY 1 argument (number) to forceclass. Or the game is improperly configured..."

func class_list(args: Array):
	var i: int = 0
	var s: String = ""
	for val in get_tree().root.get_node("Main/Game/").game_data.classes:
		s += str(i) + " - " + val.player_class_name + "\n"
		i += 1
	return s

func set_health(args: Array):
	if args.size() == 1:
		get_parent().rpc_id(multiplayer.get_unique_id(), "health_manage", float(args[0]), 0, "Forced health change")
		return "Given " + args[0] + " to your health"
	elif args.size() == 2:
		get_parent().rpc_id(multiplayer.get_unique_id(), "health_manage", float(args[0]), int(args[1]), "Forced health change")
		return "Given " + args[0] + " to your health " + args[1]
	else:
		return "Error. Needed 1 argument, if you want to add/deplete to generic
		health, or 2 args, where first arg is amount of health, and the second one is the type of health"

func give(args: Array):
	if args.size() == 1:
		if int(args[0]) < get_tree().root.get_node("Main/Game/").game_data.map_objects.size() && int(args[0]) >= 0:
			give_cmd(int(args[0]), 0)
			return "An item was given"
		else:
			return "Unknown item. Cannot spawn. E.g. to spawn an item, you need to write \"give <number>\""
	else:
		return "Unknown item. Cannot spawn. Did you input the number of item?"

func give_cmd(key: int, type: int):
	var nodepath: String
	match type:
		0:
			nodepath = "MapObjects"
		1:
			nodepath = "Npcs"
		2:
			nodepath = "Items"
	get_parent().get_parent().get_node(nodepath).rpc_id(1, "call_add_or_remove_item", true, key, get_tree().root.get_node("Main/Game/" + str(multiplayer.get_unique_id()) + "/PlayerHead/ItemSpawn").get_path())

func give_item(args: Array):
	if args.size() == 1:
		if int(args[0]) < get_tree().root.get_node("Main/Game/").game_data.items.size() && int(args[0]) >= 0:
			get_parent().get_node("InventoryUI/Inventory").add_item(int(args[0]))
			return "An item is added to inventory"
		else:
			return "Write a valid number of the item!"
	else:
		return "Write a valid number of the item! Also you need only 1 argumenm"
