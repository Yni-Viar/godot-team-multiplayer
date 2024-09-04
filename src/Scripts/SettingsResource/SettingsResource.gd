extends Resource
class_name SettingsResource

## Available languages
@export var available_languages: Array[String] = ["en", "ru"]
## Dynamic GI (only RD, not OpenGL)
## To be reworked for selecting Dynamic GI, Voxel GI and None.
@export var dynamic_gi: bool
## SSAO (only RD, not OpenGL)
@export var ssao: bool
## SSIL (only RD, not OpenGL)
@export var ssil: bool
## SSR (only RD, not OpenGL)
@export var ssr: bool
## Volumetric Fog toggle (only RD, not OpenGL). If OpenGL or disabled, standard fog is used.
@export var fog: bool
## Music
@export var music: float
## Sound
@export var sound: float
## Fullscreen toggle
@export var fullscreen: bool
## Mouse sensitivity
@export var mouse_sensitivity: float
## Window size
@export var window_size: Array[Vector2i]
## Current language
@export var ui_language: int = 0
## Glow setting
@export var glow: bool = false
## Selected window size (in Settings UI)
@export var ui_window_size: int
## V-Sync
@export var vsync: bool
## Enable or disable reflection probes
@export var reflection_probes: bool
## Enable or disable light shadows (Only LightSystemOmni and LightSystemSpot)
@export var enable_light_shadows: bool

func _init(p_dynamicgi: bool = false, p_ssao: bool = false, p_ssil: bool = false,
	p_ssr: bool = false, p_fog: bool = false, p_music: float = 1.0, p_sound: float = 1.0,
	p_fullscreen: bool = true, p_mouse_sensitivity: float = 0.05,
	p_window_size: Array[Vector2i] = [Vector2i(1920, 1080), Vector2i(1600, 900), Vector2i(1366, 768),
	Vector2i(1280, 720), Vector2i(1024, 768), Vector2i(800, 600)],
	p_ui_language: int = 0, p_glow: bool = true,
	p_game_optimizator: int = 1, p_ui_window_size: int = 0, p_vsync: bool = true,
	p_reflection_probes: bool = true, p_enable_light_shadows: bool = false):
	
	dynamic_gi = p_dynamicgi
	ssao = p_ssao
	ssil = p_ssil
	ssr = p_ssr
	fog = p_fog
	music = p_music
	sound = p_sound
	fullscreen = p_fullscreen
	mouse_sensitivity = p_mouse_sensitivity
	window_size = p_window_size
	glow = p_glow
	vsync = p_vsync
	reflection_probes = p_reflection_probes
	ui_language = p_ui_language
	ui_window_size = p_ui_window_size
	enable_light_shadows = p_enable_light_shadows
