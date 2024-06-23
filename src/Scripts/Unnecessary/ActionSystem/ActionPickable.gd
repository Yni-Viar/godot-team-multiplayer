extends InteractableRigidBody
## Picks up objects.
## Made by Yni, licensed under MIT license.
class_name ActionPickable

@export var picked_up: String = ""
@export var mouse_sensitivity = 0.05
func _input(event):
	if picked_up != "":
		if event is InputEventMouseMotion && Input.is_action_just_pressed("inspect"):
			rotate_y(-event.relative.x * mouse_sensitivity)
			rotate_x(-event.relative.y * mouse_sensitivity)

func _process(delta):
	if picked_up != "":
		global_position = get_tree().root.get_node("Main/Game/" + picked_up + "/PlayerHead/PlayerRecoil/PlayerHand").global_position

func interact(player: Node3D):
	if picked_up == "":
		rpc("pick", player.get_path())
	elif picked_up == str(multiplayer.get_unique_id()):
		call("use", self)

func interact_alt(player: Node3D):
	if picked_up == str(multiplayer.get_unique_id()):
		rpc("throw", player.get_path())

func use(player: Node3D):
	pass

## Picks up an object
@rpc("any_peer", "call_local")
func pick(player: String):
	freeze = true
	picked_up = str(multiplayer.get_remote_sender_id())
	get_node(player).using_item = name
	
## Throws an object
@rpc("any_peer", "call_local")
func throw(player: String):
	freeze = false
	picked_up = ""
	get_node(player).using_item = ""
