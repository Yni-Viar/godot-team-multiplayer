extends Node3D
class_name ItemUse

var enable_using = true
@export var one_time_use: bool
@export var index: int
var player_path: PlayerScript

# Called when the node enters the scene tree for the first time.
func _ready():
	if !get_parent().get_parent().get_parent().get_parent().is_multiplayer_authority():
		set_physics_process(false)
	else:
		player_path = get_parent().get_parent().get_parent().get_parent()
	on_ready()

func on_ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	on_update(delta)

func on_update(delta):
	pass

func on_use(player):
	if one_time_use:
		player.get_node("InventoryUI/Inventory").remove_item_by_index(index, false)
		if get_tree().root.get_node("Main/Game/PlayerUI").special_screen && !Settings.touchscreen:
			get_tree().root.get_node("Main/Game/PlayerUI").special_screen = false
	queue_free()
