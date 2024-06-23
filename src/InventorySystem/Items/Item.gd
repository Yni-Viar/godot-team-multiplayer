extends Resource
class_name Item

@export var id: int
@export var name: String
@export var texture: Texture2D
@export var size: Vector2i
@export var pickable_path: String
@export var pickup_sound_path: String
@export var first_person_prefab_path: String
@export var one_time_use: bool
@export var upgrade_rough: Array[int]
@export var upgrade_coarse: Array[int]
@export var upgrade_one_to_one: Array[int]
@export var upgrade_fine: Array[int]
@export var upgrade_very_fine: Array[int]


# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(p_id = 0, p_name = "", p_texture = null, p_size = Vector2i.ZERO, p_pickable_path = "", p_pickup_sound_path = "",
p_first_person_prefab_path = "", p_one_time_use = false, p_rough: Array[int] = [], p_coarse: Array[int] = [],
p_one_to_one: Array[int] = [], p_fine: Array[int] = [], p_very_fine: Array[int] = []):
	id = p_id
	name = p_name
	texture = p_texture
	size = p_size
	pickable_path = p_pickable_path
	pickup_sound_path = p_pickup_sound_path
	first_person_prefab_path = p_first_person_prefab_path
	one_time_use = p_one_time_use
	upgrade_rough = p_rough
	upgrade_coarse = p_coarse
	upgrade_one_to_one = p_one_to_one
	upgrade_fine = p_fine
	upgrade_very_fine = p_very_fine
