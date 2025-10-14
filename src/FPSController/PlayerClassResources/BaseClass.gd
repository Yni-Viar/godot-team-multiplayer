extends Resource
## Player Class Resource
## Made by Yni, licensed under MIT license.
class_name BaseClass

## Name of the class. Appears on HUD when forceclassing.
@export var player_class_name: String = ""
## Description of the class. Appears on HUD when forceclassing.
@export_multiline var player_class_description: String = ""
## Class' spawnpoints.
@export var spawn_points: Array[String] = []
## Model and behaviour source.
@export var player_model_source: String = ""
## Ragdoll or death anim source.
@export var player_ragdoll_source: String = ""
## Speed of class.
@export var speed: float = 4.5
## How much the player can jump?
@export var jump: float = 4.5
## Enable sprint.
@export var sprint_enabled: bool = false
## Enable moving sounds.
@export var move_sounds_enabled: bool = false
## Footstep sounds. Not required if MoveSounds are disabled.
@export var footstep_sounds: Array[String] = []
## Sprint sounds. Not required if MoveSounds or sprint are disabled.
@export var sprint_sounds: Array[String] = []
## Unique Number. Set -1 for common entities (such as humans),
## -2 for spectators, and 0 and above for entities with special abilities.
@export var unique_type_id: int = 0
## Health (you can set more than one health parameter)
@export var health: Array[float] = [100]
## If custom spawn, the player spawns not on spawn point, but on place,
## where they were forceclassed.
@export var custom_spawn: bool = false
## Custom camera (used by ComputerPlayerScript). Available since 0.6.0.
@export var custom_camera: bool = false
## Default camera's shader. Available since 0.6.0.
@export var custom_shader: String = ""
## Preloaded items.
@export var preloaded_items: Array[String]
## Color of class.
@export var class_color: Color = Color.BLACK
## Enables or disables inventory for this class. Available in TGPY since 0.9.0-dev
@export var enable_inventory: bool = false
## Enables movement
@export var can_move: bool = true
## Player team
@export var team: int = 0
