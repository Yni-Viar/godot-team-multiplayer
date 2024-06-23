extends Node3D
## Made by Yni, licensed under CC0.

enum ObjectType {static_prefab, animated, ragdoll}
@export var state: String
@export var type: ObjectType = ObjectType.static_prefab
@export var armature_name: String = "Armature"

# Called when the node enters the scene tree for the first time.
func _ready():
	match type:
		ObjectType.animated:
			set_state(state)
		ObjectType.ragdoll:
			get_node(armature_name + "/Skeleton3D").physical_bones_start_simulation()
	await get_tree().create_timer(30.0).timeout
	despawn()

func set_state(s):
	if get_node("AnimationPlayer").current_animation != s:
		get_node("AnimationPlayer").play(s)

func despawn():
	if type == ObjectType.ragdoll:
		get_node(armature_name + "/Skeleton3D").physical_bones_stop_simulation()
	queue_free()
