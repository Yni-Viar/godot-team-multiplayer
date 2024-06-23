extends ColorRect


# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func _gui_input(event):
	if Input.is_action_just_released("inventory_select"):
		get_parent().get_parent().get_parent().rpc("hold_item", -1)
		get_tree().root.get_node("Main/Game/PlayerUI").input_values("inventory")
