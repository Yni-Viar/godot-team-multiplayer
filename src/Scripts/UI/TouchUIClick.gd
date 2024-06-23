extends TextureButton

## Part of touch controls (touch button)
## Made by Yni, licensed under CC0.

func _on_pressed():
	Input.action_press("interact")


func _on_rclick_pressed():
	Input.action_press("interact_alt")
