extends Resource
class_name SettingsResource

## KeyBoard, MouseButton, JoyPad
enum InputMethod {KB, MB, JP}

## Available languages
@export var available_languages: Array[String] = ["en", "ru"]
## Dynamic GI (only RD, not OpenGL)
## To be reworked for selecting Dynamic GI, Voxel GI and None.
@export var dynamic_gi: bool = false
## SSAO (only RD, not OpenGL)
@export var ssao: bool = false
## SSIL (only RD, not OpenGL)
@export var ssil: bool = false
## SSR (only RD, not OpenGL)
@export var ssr: bool = false
## Volumetric Fog toggle (only RD, not OpenGL). If OpenGL or disabled, standard fog is used.
@export var fog: bool = false
## Music
@export var music: float = 1.0
## Sound
@export var sound: float = 1.0
## Fullscreen toggle
@export var fullscreen: bool = true
## Mouse sensitivity
@export var mouse_sensitivity: float = 0.05
## Window size
@export var window_size: Array[Vector2i] = [Vector2i(1920, 1080), Vector2i(1600, 900), Vector2i(1366, 768),
	Vector2i(1280, 720), Vector2i(1024, 768), Vector2i(800, 600)]
## Current language
@export var ui_language: int = 0
## Glow setting
@export var glow: bool = false
## Selected window size (in Settings UI)
@export var ui_window_size: int = 0
## V-Sync
@export var vsync: bool = true
## Enable or disable reflection probes
@export var reflection_probes: bool = true
## Enable or disable light shadows (Only LightSystemOmni and LightSystemSpot)
@export var enable_light_shadows: bool = false

@export var keybinds: Dictionary[String, Array] = {
	"move_forward": [InputMethod.KB, KEY_W],
	"move_backward": [InputMethod.KB, KEY_S],
	"move_left": [InputMethod.KB, KEY_A],
	"move_right": [InputMethod.KB, KEY_D],
	"move_jump": [InputMethod.KB, KEY_SPACE],
	"move_sprint": [InputMethod.KB, KEY_SHIFT],
	"attack": [InputMethod.MB, MOUSE_BUTTON_LEFT],
	"human_inventory": [InputMethod.KB, KEY_TAB],
	"inventory_select": [InputMethod.MB, MOUSE_BUTTON_LEFT],
	"inventory_remove_item": [InputMethod.MB, MOUSE_BUTTON_RIGHT],
	"player_list": [InputMethod.KB, KEY_N]
}
