extends Node3D
## Recoil System (MIT License)
##
## Copyright (c) 2024 AceSpectre
class_name PlayerRecoil

# Rotations
var currentRotation : Vector3
var targetRotation : Vector3

# Recoil vectors
@export var recoil : Vector3
@export var aimRecoil : Vector3

# Settings
@export var snappiness : float
@export var returnSpeed : float

func _process(delta):
	# Lerp target rotation to (0,0,0) and lerp current rotation to target rotation
	targetRotation = lerp(targetRotation, Vector3.ZERO, returnSpeed * delta)
	currentRotation = lerp(currentRotation, targetRotation, snappiness * delta)
	
	# Set rotation
	rotation = currentRotation
	
	# Camera z axis tilt fix, ignored if tilt intentional
	# I have no idea why it tilts if recoil.z is set to 0
	if recoil.z == 0 and aimRecoil.z == 0:
		global_rotation.z = 0

func recoil_fire(is_aiming : bool = false):
	if is_aiming:
		targetRotation += Vector3(aimRecoil.x, randf_range(-aimRecoil.y, aimRecoil.y), randf_range(-aimRecoil.z, aimRecoil.z))
	else:
		targetRotation += Vector3(recoil.x, randf_range(-recoil.y, recoil.y), randf_range(-recoil.z, recoil.z))

func set_recoil(new_recoil : Vector3):
	recoil = new_recoil

func set_aim_recoil(new_recoil : Vector3):
	aimRecoil = new_recoil
