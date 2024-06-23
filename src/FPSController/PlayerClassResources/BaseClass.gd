extends Resource
## Player Class Resource
## Made by Yni, licensed under MIT license.
class_name BaseClass

## Name of the class. Appears on HUD when forceclassing.
@export var player_class_name: String
## Description of the class. Appears on HUD when forceclassing.
@export_multiline var player_class_description: String
## Class' spawnpoints.
@export var spawn_points: Array[String]
## Model and behaviour source.
@export var player_model_source: String
## Ragdoll or death anim source.
@export var player_ragdoll_source: String
## Speed of class.
@export var speed: float
## How much the player can jump?
@export var jump: float
## Enable sprint.
@export var sprint_enabled: bool
## Enable moving sounds.
@export var move_sounds_enabled: bool
## Footstep sounds. Not required if MoveSounds are disabled.
@export var footstep_sounds: Array[String]
## Sprint sounds. Not required if MoveSounds or sprint are disabled.
@export var sprint_sounds: Array[String]
## Unique Number. Set -1 for common entities (such as humans),
## -2 for spectators, and 0 and above for entities with special abilities.
@export var unique_type_id: int
## Health (you can set more than one health parameter)
@export var health: Array[float]
## If custom spawn, the player spawns not on spawn point, but on place,
## where they were forceclassed.
@export var custom_spawn: bool
## Custom camera (used by ComputerPlayerScript). Available since 0.6.0.
@export var custom_camera: bool
## Default camera's shder. Available since 0.6.0.
@export var custom_shader: String
# Preloaded items.
# @export var preloaded_items: Array[String]
## Color of class.
@export var class_color: Color
## Enables or disables inventory for this class. Available in TGPY since 0.9.0-dev
@export var enable_inventory: bool
## Enables movement
@export var can_move: bool



# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(p_player_class_name: String = "", p_player_class_description: String = "",
p_spawn_points: Array[String] = [], p_player_model_source: String = "", p_player_ragdoll_source: String = "",
p_speed: float = 4.5, p_jump: float = 4.5, p_sprint_enabled: bool = false, p_move_sounds_enabled: bool = false,
p_footstep_sounds: Array[String] = [], p_sprint_sounds: Array[String] = [], p_unique_type_id: int = 0,
p_health: Array[float] = [100], p_custom_spawn: bool = false, p_custom_camera: bool = false, p_custom_shader: String = "",
p_class_color: Color = Color.BLACK, p_enable_inventory: bool = false, p_can_move: bool = true):
	player_class_name = p_player_class_name
	player_class_description = p_player_class_description
	spawn_points = p_spawn_points
	player_model_source = p_player_model_source
	player_ragdoll_source = p_player_ragdoll_source
	speed = p_speed
	sprint_enabled = p_sprint_enabled
	move_sounds_enabled = p_move_sounds_enabled
	footstep_sounds = p_footstep_sounds
	sprint_sounds = p_sprint_sounds
	unique_type_id = p_unique_type_id
	health = p_health
	custom_spawn = p_custom_spawn
	custom_camera = p_custom_camera
	custom_shader = p_custom_shader
	class_color = p_class_color
	enable_inventory = p_enable_inventory
	can_move = p_can_move
