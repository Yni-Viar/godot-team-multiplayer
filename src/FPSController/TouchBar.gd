extends Panel

## Touchscreen function, used to rotate player.
## Made by Yni, licensed under CC0.

@onready var player_head = get_parent().get_parent().get_node("PlayerHead")

func _on_gui_input(event):
	if event is InputEventScreenDrag:
		get_parent().get_parent().rotate_y(-event.relative.x * Settings.mouse_sensitivity * 0.05)
		player_head.rotate_x(clamp(-event.relative.y * Settings.mouse_sensitivity * 0.05, -90, 90))
		
		var camera_rot = player_head.rotation_degrees
		camera_rot.x = clamp(player_head.rotation_degrees.x, -85, 85)
		player_head.rotation_degrees = camera_rot
