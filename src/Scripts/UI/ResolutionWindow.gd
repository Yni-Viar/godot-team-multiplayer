extends IngameWindow
class_name AddResolutionSetting

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continue_pressed() -> void:
	if $Control/X.text.is_valid_int() && $Control/Y.text.is_valid_int():
		Settings.setting_res.window_size.append(Vector2i(int($Control/X.text), int($Control/Y.text)))
		Settings.save_resource(Settings.setting_res)
		get_parent().call("add_new_resolution", $Control/X.text, $Control/Y.text)
	else:
		print("X and/or Y is not number, resolution won't be added")
