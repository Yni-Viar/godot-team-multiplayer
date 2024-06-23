extends SpotLight3D
## Light system. Allow to turn on and off lights.
## Made by Yni, licensed under CC0.
class_name LightSystemSpot

@export var min_light_energy: float = 0.2
@export var max_light_energy: float = 1
## turns lights off
func turn_lights_off():
	light_energy = max_light_energy + 1
	await get_tree().create_timer(0.2).timeout
	light_energy = 0
## turns lights on
func turn_lights_on():
	light_energy = max_light_energy
