extends Node
## Settings script. It's values form the game settings...
## This script is a singleton.
## Made by Yni, licensed under CC0. 

## Game languages
var available_languages: Array[String] = ["en"]
## Dynamic GI (SDFGI, HDDAGI (for newer Godot versions)) (works on Forward renderer only)
var dynamic_gi: bool
## Screen-space Ambient Occlusion (works on Forward renderer only)
var ssao: bool
## Screen-space indirect lighting (works on Forward renderer only)
var ssil: bool
## Screen-space reflections (works on Forward renderer only)
var ssr: bool
## Standard fog is false, Volumetric if true (Should be always false for OpenGL Compatibility renderer)
var fog: bool
## Music volume
var music: float
## Sound volume
var sound: float
## Fullscreen toggle.
var fullscreen: bool
## Mouse Sensitivity
var mouse_sensitivity: float
## Window size. Should not be changed on mobile platforms.
var window_size: Vector2i
## Current language
var language: String = "en"
## Glow (OpenGL Compatibility will support glow only in Godot 4.3 and newer)
var glow: bool = false
## Touchscreen support.
var touchscreen: bool = false
## Default settings.
var default_settings: Dictionary = {
	"DynamicGi": false,
	"Ssao": false,
	"Ssil": false,
	"Ssr": false,
	"Fog": false,
	"Music": 1.0,
	"Sound": 1.0,
	"Fullscreen": false,
	"MouseSensitivity": 0.05,
	"WindowSize": Vector2i(1366, 768),
	"Language": available_languages[0],
	"Glow": false,
	"Touchscreen": DisplayServer.is_touchscreen_available()
}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_ini(true)
## Saves default settings
func save_default_settings():
	var ini: IniParser = IniParser.new()
	ini.save_ini("Settings", default_settings.keys(), default_settings.values(), "user://settings.ini")
	load_ini()
## Loads INI Settings file
func load_ini(check_for_missing: bool = false):
	if !FileAccess.file_exists("user://settings.ini"):
		save_default_settings()
	
	if check_for_missing:
		check_if_a_setting_exist(default_settings.keys(), default_settings.values())
	
	var ini: IniParser = IniParser.new()
	var result: Array = ini.load_ini("user://settings.ini", "Settings", default_settings.keys())
	
	dynamic_gi = bool(result[0])
	ssao = bool(result[1])
	ssil = bool(result[2])
	ssr = bool(result[3])
	fog = bool(result[4])
	music = float(result[5])
	sound = float(result[6])
	fullscreen = bool(result[7])
	mouse_sensitivity = float(result[8])
	window_size = Vector2i(result[9])
	language = str(result[10])
	glow = bool(result[11])
	touchscreen = bool(result[12])
## Checks if a setting exist, if not -> replaces with default value. 
func check_if_a_setting_exist(setting_values: Array, default_values: Array):
	var config: ConfigFile = ConfigFile.new()
	var err = config.load("user://settings.ini")
	
	if err != OK:
		save_default_settings()
		print("The Settings has not saved, saving default settings...")
	for i in range(setting_values.size()):
		if !config.has_section_key("Settings", setting_values[i]):
			config.set_value("Settings", setting_values[i], default_values[i])
	config.save("user://settings.ini")
