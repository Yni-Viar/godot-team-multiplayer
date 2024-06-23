extends BasePlayerScript
## Made by Yni, licensed under CC0.

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().get_parent().set_collision_mask_value(3, false)
