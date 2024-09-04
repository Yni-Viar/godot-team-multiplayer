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
	setting_res = load_resource()
	# Add custom windows sizes.
	for v in setting_res.window_size:
		window_size.append(v)

func load_resource() -> SettingsResource:
	if ResourceLoader.exists("user://Settings.tres"):
		return load("user://Settings.tres")
	else:
		if RenderingServer.get_rendering_device() != null:
			var res = load("res://Scripts/SettingsResource/Presets/RD/Medium.tres")
			save_resource(res)
			return res
		else:
			var res = load("res://Scripts/SettingsResource/Presets/OpenGL/Low.tres")
			save_resource(res)
			return res

func save_resource(res):
	ResourceSaver.save(res, "user://Settings.tres")
	emit_signal("settings_saved")
