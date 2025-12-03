extends GridContainer

# Made by Yni. Licensed under MIT License.

var settings_key: Dictionary[String, String] = {
	"MF": "move_forward",
	"MB": "move_backward",
	"ML": "move_left",
	"MR": "move_right",
	"MJ": "move_jump",
	"MS": "move_sprint",
	"A": "attack",
	"HI": "human_inventory",
	"HIS": "inventory_select",
	"HIR": "inventory_remove_item",
	"PL": "player_list"
}
var listen_to_keybind: bool = false
var current_setting_to_change: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	re_parse()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if listen_to_keybind && current_setting_to_change >= 0 && current_setting_to_change < settings_key.size():
		if event is InputEventKey:
			Settings.set_keybind(settings_key[settings_key.keys()[current_setting_to_change]], 0, event.physical_keycode)
		if event is InputEventMouseButton:
			Settings.set_keybind(settings_key[settings_key.keys()[current_setting_to_change]], 1, event.button_index)
		re_parse()
		listen_to_keybind = false

func re_parse():
	for str in settings_key.keys():
		if get_node_or_null(str + "Button") != null:
			get_node(str + "Button").text = InputMap.action_get_events(settings_key[str])[0].as_text()

func _on_mf_button_pressed() -> void:
	listen_to_keybind = true
	$MFButton.text = "KEY_LISTENING"
	current_setting_to_change = 0


func _on_mb_button_pressed() -> void:
	listen_to_keybind = true
	$MBButton.text = "KEY_LISTENING"
	current_setting_to_change = 1


func _on_ml_button_pressed() -> void:
	listen_to_keybind = true
	$MLButton.text = "KEY_LISTENING"
	current_setting_to_change = 2


func _on_mr_button_pressed() -> void:
	listen_to_keybind = true
	$MRButton.text = "KEY_LISTENING"
	current_setting_to_change = 3


func _on_mj_button_pressed() -> void:
	listen_to_keybind = true
	$MJButton.text = "KEY_LISTENING"
	current_setting_to_change = 4


func _on_ms_button_pressed() -> void:
	listen_to_keybind = true
	$MSButton.text = "KEY_LISTENING"
	current_setting_to_change = 5


func _on_a_button_pressed() -> void:
	listen_to_keybind = true
	$AButton.text = "KEY_LISTENING"
	current_setting_to_change = 6


func _on_hi_button_pressed() -> void:
	listen_to_keybind = true
	$HIButton.text = "KEY_LISTENING"
	current_setting_to_change = 7


func _on_his_button_pressed() -> void:
	listen_to_keybind = true
	$HISButton.text = "KEY_LISTENING"
	current_setting_to_change = 8


func _on_hir_button_pressed() -> void:
	listen_to_keybind = true
	$HIRButton.text = "KEY_LISTENING"
	current_setting_to_change = 9


func _on_pl_button_pressed() -> void:
	listen_to_keybind = true
	$PLButton.text = "KEY_LISTENING"
	current_setting_to_change = 10
