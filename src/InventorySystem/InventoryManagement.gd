extends Control
class_name InventoryPanel

signal item_added(item_id: int)
signal item_removed(item_id: int)
@onready var inventory_panel = $InventoryPanel
@export var tile_size: Vector2 = Vector2(32, 32)
@export var dimensions: Vector2i = Vector2i(4, 4)
@export var max_items_outside_inventory = 1
var item_res_path: GameData
var item_counter: int = 0
var items_array: Array[TextureRect] = []
var is_item_selected: bool = false
var selected_item: TextureRect
var is_dragging: bool = false
var item_prev_position: Vector2 = Vector2.ZERO
var selected_item_z_index: int = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	item_res_path = get_tree().root.get_node("Main/Game").game_data

@rpc("any_peer", "call_local")
func add_item(item_id: int):
	if item_counter >= max_items_outside_inventory:
		return
	else:
		item_counter += 1
	var item: Item = item_res_path.items[item_id]
	var item_prefab: InventorySlot = InventorySlot.new()
	item_prefab.global_position = $DockPanel.global_position
	item_prefab.item_id = item.id
	item_prefab.texture = item.texture
	item_prefab.mouse_filter = Control.MOUSE_FILTER_STOP
	item_prefab.connect("gui_input", Callable(self, "on_gui_input").bind(item_prefab))
	add_child(item_prefab, true)

func on_gui_input(event: InputEvent, prefab: InventorySlot):
	if event.is_action_pressed("inventory_select"):
		is_item_selected = true
		selected_item = prefab
		selected_item.z_index = selected_item_z_index
		item_prev_position = prefab.position
	
	if Input.is_action_just_released("inventory_select"):
		get_parent().get_parent().rpc("hold_item", prefab.item_id)
		get_tree().root.get_node("Main/Game/PlayerUI").input_values("inventory")
	
	#if event is InputEventMouseMotion:
		#if is_item_selected:
			#is_dragging = true
	# touch screen
	#elif event is InputEventScreenDrag:
		#if is_item_selected:
			#is_dragging = true
	
	if event.is_action_released("inventory_select"):
		selected_item.z_index = 0
		
		is_item_selected = false
		is_dragging = false
		selected_item = null
	
	if event.is_action_released("inventory_remove_item"):
		remove_item(prefab.get_path(), true)
## Moves item in the inventory
func item_move(item: InventorySlot, pos: Vector2):
	if item.first_start:
		item_counter -= 1
		items_array.append(item)
		item_added.emit(item.item_id)
		item.first_start = false
	item.position = ($InventoryPanel.global_position + pos).snapped(tile_size)
	if !$InventoryPanel.get_rect().intersection(item.get_rect()) == item.get_rect():
		item.position = item_prev_position
	for item_check in items_array:
		if item_check.name != item.name:
			if item_check.get_rect().intersection(item.get_rect()) == item.get_rect():
				item.position = item_prev_position
	item_prev_position = Vector2.ZERO
## Removes item and calls signal (e.g. for dropping item on the ground)
@rpc("any_peer", "call_local")
func remove_item(prefab_path: String, spawn_item: bool):
	var prefab = get_node(prefab_path)
	prefab.disconnect("gui_input", Callable(self, "on_gui_input").bind(prefab))
	if spawn_item:
		get_tree().root.get_node("Main/Game/Items").rpc("call_add_or_remove_item",true, prefab.item_id,
			"/root/Main/Game/" + str(multiplayer.get_unique_id()) + "/PlayerHead/ItemSpawn")
	get_tree().root.get_node("Main/Game/" + str(multiplayer.get_unique_id())).rpc("hold_item", -1)
	item_removed.emit(prefab.item_id)
	items_array.erase(prefab)
	prefab.queue_free()

func remove_item_by_index(index: int, spawn_item: bool):
	var item: Item = item_res_path.items[index]
	for node in get_children():
		if "item_id" in node:
			if node.item_id == index:
				remove_item(node.get_path(), spawn_item)
				return
