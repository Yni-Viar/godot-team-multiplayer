extends Node3D
class_name InteractableNode

## Base class for interactable static nodes.
## Made by Yni, licensed under MIT license.

## Enable or disable this control
@export var enabled: bool = true
## Enable sound
@export var has_sound: bool = true
## Path to OK sound
@export var sound_ok_path: String = "res://Sounds/Interact/button.ogg"
## Path to error sound
@export var sound_error_path: String = "res://Sounds/Interact/button_error.ogg"
## Path to sound node.
@export var node: String = "ButtonSound"

func interact(player: Node3D):
	var sfx: AudioStreamPlayer3D = get_node(node)
	
	if has_sound:
		if !enabled:
			sfx.stream = load(sound_error_path)
			sfx.play()
		else:
			sfx.stream = load(sound_ok_path)
			sfx.play()

func interact_alt(player: Node3D):
	var sfx: AudioStreamPlayer3D = get_node(node)
	
	if has_sound:
		if !enabled:
			sfx.stream = load(sound_error_path)
			sfx.play()
		else:
			sfx.stream = load(sound_ok_path)
			sfx.play()
