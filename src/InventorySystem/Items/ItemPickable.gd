extends InteractableRigidBody
class_name ItemPickable

@export var item: Item

func interact(player: Node3D):
	rpc_id(1, "add_to_inventory")

@rpc("any_peer", "call_local")
func add_to_inventory():
	get_tree().root.get_node("Main/Game/" + str(multiplayer.get_unique_id()) + "/InventoryUI/Inventory").rpc_id(multiplayer.get_unique_id(), "add_item", item.id)
	rpc("clear_world_item")

@rpc("any_peer", "call_local")
func clear_world_item():
	queue_free()
