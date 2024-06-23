extends Control
## Player ingame UI controller.
## Made by Yni, licensed under CC0. 

## If special screen, mouse cursor shows, if not - it is captured.
var special_screen: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if Settings.touchscreen:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if special_screen:
		$Cursor.hide()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		$Cursor.show()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		input_values("exitgame")
	if Input.is_action_just_pressed("player_list"):
		input_values("playerlist")
	if Input.is_action_just_pressed("console"):
		input_values("console")
	if Input.is_action_just_pressed("human_inventory"):
		input_values("inventory")
## Switch-case function, makes nodes visible or not by calling it's internal names.
func input_values(state: String):
	match state:
		"console":
			if !special_screen:
				#$AdminConsole.visible = true
				get_tree().root.get_node("Main/CanvasLayer/InGameConsole").visible = true
				special_screen = true
			else:
				#$AdminConsole.visible = false
				if get_tree().root.get_node("Main/CanvasLayer/InGameConsole").visible:
					get_tree().root.get_node("Main/CanvasLayer/InGameConsole").hide()
				special_screen = false
		"playerlist":
			if $PlayerListPanel.visible:
				for node in $PlayerListPanel/PlayerList.get_children():
					node.queue_free()
				$PlayerListPanel.visible = false
				special_screen = false
			elif !special_screen:
				for item in get_parent().players_list:
					var label: Label = Label.new()
					label.text = get_parent().get_node(str(item)).player_name
					$PlayerListPanel/PlayerList.add_child(label)
				$PlayerListPanel.visible = true
				special_screen = true
		"exitgame":
			if !special_screen:
				$PauseMenu.show()
				special_screen = true
			else:
				$PauseMenu.hide()
				special_screen = false
		"inventory":
			if !special_screen:
				get_tree().root.get_node("Main/Game/" + str(multiplayer.get_unique_id()) + "/InventoryUI").show()
				special_screen = true
			else:
				get_tree().root.get_node("Main/Game/" + str(multiplayer.get_unique_id()) + "/InventoryUI").hide()
				special_screen = false


func _on_exit_button_pressed():
	get_tree().root.get_node("Main").server_disconnected()
