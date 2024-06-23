extends RigidBody3D
## Base class for interactable RigidBodies.
## Made by Yni, licensed under CC0.
class_name InteractableRigidBody

## Enable or disable sounds
@export var has_sound: bool
## Path to AudioStreamPlayer node
@export var sound_path: String

func interact(player: Node3D):
	if has_sound:
		var sfx: AudioStreamPlayer3D = get_node(sound_path)
		sfx.play()

func interact_alt(player: Node3D):
	if has_sound:
		var sfx: AudioStreamPlayer3D = get_node(sound_path)
		sfx.play()
