extends TextureRect
class_name InventorySlot

@export var item_id: int
## Checks, if the item is ACTUALLY put in the inventory, and is not in the dock
var first_start: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Set texture preview
func _get_drag_data(at_position):
	var preview: TextureRect = TextureRect.new()
	preview.texture = texture
	set_drag_preview(preview)
	return self
