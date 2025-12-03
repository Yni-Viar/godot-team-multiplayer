extends Node

enum Stages {release, testing, dev}
enum ItemType {item, map_object, npc}

signal settings_saved

## Migrated from Globals.
## Game's data compatibility for modding.
const DATA_COMPATIBILITY: String = "0.0.1"
## Migrated from Globals.
## Game's data compatibility for modding.
const CURRENT_STAGE: Stages = Stages.dev
## Available languages
var available_languages: Array[String] = ["en", "ru"]
## Necessary for overriding Godot bug.
## Checks when settings would be loaded.
var first_start: bool = true
## Settings resource
var setting_res: SettingsResource
## Default windows sizes.
var window_size: Array[Vector2i] = [Vector2i(1920, 1080), Vector2i(1600, 900), Vector2i(1366, 768),
						Vector2i(1280, 720), Vector2i(1024, 768), Vector2i(800, 600)]
## Touchscreen toggle
var touchscreen: bool = DisplayServer.is_touchscreen_available()

func _init():
	load_resource()
	# Add custom windows sizes.
	for v in setting_res.window_size:
		window_size.append(v)


## Sometimes ago it was a great function. Now it is just a stub, that calls ResourceStorage and loads settings
func load_resource():
	if OS.get_name() != "Web":
		var settings_from_file = ResourceStorage.load_resource("user://Settings.bin", "SettingsResource")
		if settings_from_file != null:
			setting_res = settings_from_file
			set_default_keybinds()
		else:
			load_default_settings()
	else:
		load_default_settings()

func load_default_settings():
	#if OS.get_name() != "Web" || OS.get_name() != "Android":
	var res = load("res://Scripts/SettingsResource/Presets/OpenGL/Low.tres")
	save_resource(res)
	setting_res = res
	set_default_keybinds()
	#else:
		#var res = load("res://Scripts/SettingsResource/Presets/OpenGL/Lowest.tres")
		#save_resource(res)
		#setting_res = res

## Sometimes ago it was a great function. Now it is just a stub, that calls ResourceStorage and saves settings
func save_resource(res):
	if OS.get_name() != "Web":
		ResourceStorage.save_resource("user://Settings.bin", res)
		emit_signal("settings_saved")

func set_default_keybinds():
	for value in setting_res.keybinds.keys():
		set_keybind(value, setting_res.keybinds[value][0], setting_res.keybinds[value][1])

func set_keybind(action_name: String, key_type: int, key: int):
	InputMap.action_erase_events(action_name)
	match key_type:
		0:
			var event: InputEventKey = InputEventKey.new()
			event.physical_keycode = key as Key
			InputMap.action_add_event(action_name, event)
		1:
			var event: InputEventMouseButton = InputEventMouseButton.new()
			event.button_index = key as MouseButton
			InputMap.action_add_event(action_name, event)
		2:
			print("Gamepad support is not implemented.")
	setting_res.keybinds[action_name] = [key_type, key]
	save_resource(setting_res)
