extends Panel

## Settings UI. Seyts settings in main menu.
## Made by Yni, licensed under CC0.

# Called when the node enters the scene tree for the first time.
func _ready():
	$ScrollContainer/VBoxContainer/DynamicGISet.button_pressed = Settings.dynamic_gi
	$ScrollContainer/VBoxContainer/SSAOSet.button_pressed = Settings.ssao
	$ScrollContainer/VBoxContainer/SSILSet.button_pressed = Settings.ssil
	$ScrollContainer/VBoxContainer/SSRSet.button_pressed = Settings.ssr
	#$ScrollContainer/VBoxContainer/FogSet.button_pressed = Settings.fog
	$ScrollContainer/VBoxContainer/FullscreenSet.button_pressed = Settings.fullscreen
	$ScrollContainer/VBoxContainer/MouseSensSet.value = Settings.mouse_sensitivity
	$ScrollContainer/VBoxContainer/MusicSet.value = Settings.music
	$ScrollContainer/VBoxContainer/SoundSet.value = Settings.sound
	$ScrollContainer/VBoxContainer/GlowSet.button_pressed = Settings.glow
	#$ScrollContainer/VBoxContainer/GraphicDeviceSet.selected = Settings.renderer
	graphic_device_check()

func save_current_Settings():
	var ini: IniParser = IniParser.new()
	ini.save_ini("Settings", ["DynamicGi", "Ssao", "Ssil", "Ssr", #"Fog",
	"Music", "Sound", "Fullscreen", "MouseSensitivity",
	"WindowSize", "Language", "Glow"], [Settings.dynamic_gi, Settings.ssao, Settings.ssil, Settings.ssr, #Settings.fog,
	Settings.music, Settings.sound, Settings.fullscreen, Settings.mouse_sensitivity, Settings.window_size,
	Settings.language, Settings.glow], "user://Settings.ini")

func _on_language_set_item_selected(index):
	TranslationServer.set_locale(Settings.available_languages[index])
	Settings.language = Settings.available_languages[index]
	save_current_Settings()


func _on_window_size_set_item_selected(index):
	match index:
		0:
			Settings.window_size = Vector2i(1920, 1080)
		1:
			Settings.window_size = Vector2i(1600, 900)
		2:
			Settings.window_size = Vector2i(1366, 768)
		3:
			Settings.window_size = Vector2i(1280, 720)
		4:
			Settings.window_size = Vector2i(1024, 768)
		5:
			Settings.window_size = Vector2i(800, 600)
	get_window().size = Settings.window_size
	save_current_Settings()


func _on_fullscreen_set_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Settings.fullscreen = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		Settings.fullscreen = false
	save_current_Settings()

func _on_dynamic_gi_set_toggled(toggled_on):
	if toggled_on:
		Settings.dynamic_gi = true
	else:
		Settings.dynamic_gi = false
	save_current_Settings()


func _on_ssao_set_toggled(toggled_on):
	if toggled_on:
		Settings.ssao = true
	else:
		Settings.ssao = false
	save_current_Settings()


func _on_ssil_set_toggled(toggled_on):
	if toggled_on:
		Settings.ssil = true
	else:
		Settings.ssil = false
	save_current_Settings()


func _on_ssr_set_toggled(toggled_on):
	if toggled_on:
		Settings.ssr = true
	else:
		Settings.ssr = false
	save_current_Settings()


func _on_music_set_drag_ended(value_changed):
	if value_changed:
		Settings.music = $ScrollContainer/VBoxContainer/MusicSet.value
		audio_Settings(1, Settings.music)
		save_current_Settings()


func _on_sound_set_drag_ended(value_changed):
	if value_changed:
		Settings.sound = $ScrollContainer/VBoxContainer/SoundSet.value
		audio_Settings(0, Settings.music)
		save_current_Settings()
		$SoundTest.play()


func _on_mouse_sens_set_drag_ended(value_changed):
	if value_changed:
		Settings.mouse_sensitivity = $ScrollContainer/VBoxContainer/MouseSensSet.value
		save_current_Settings()

## Sets the audio bus
func audio_Settings(bus: int, val: float):
	AudioServer.set_bus_volume_db(bus, linear_to_db(val))
	if val < 0.01:
		AudioServer.set_bus_mute(bus, true)
	elif val >= 0.01 && AudioServer.is_bus_mute(bus):
		AudioServer.set_bus_mute(bus, false)


func _on_back_pressed():
	get_parent().hide()


func _on_glow_set_toggled(toggled_on):
	if toggled_on:
		Settings.glow = true
	else:
		Settings.glow = false
	save_current_Settings()

func graphic_device_check():
	if ProjectSettings.get_setting("rendering/renderer/rendering_method") == "gl_compatibility":
		$ScrollContainer/VBoxContainer/DynamicGISet.button_pressed = false
		$ScrollContainer/VBoxContainer/SSAOSet.button_pressed = false
		$ScrollContainer/VBoxContainer/SSILSet.button_pressed = false
		$ScrollContainer/VBoxContainer/SSRSet.button_pressed = false
		$ScrollContainer/VBoxContainer/DynamicGISet.disabled = true
		$ScrollContainer/VBoxContainer/SSAOSet.disabled = true
		$ScrollContainer/VBoxContainer/SSILSet.disabled = true
		$ScrollContainer/VBoxContainer/SSRSet.disabled = true
		$ScrollContainer/VBoxContainer/DynamicGISet.hide()
		$ScrollContainer/VBoxContainer/SSAOSet.hide()
		$ScrollContainer/VBoxContainer/SSILSet.hide()
		$ScrollContainer/VBoxContainer/SSRSet.hide()
	elif ProjectSettings.get_setting("rendering/renderer/rendering_method") == "forward_plus":
		$ScrollContainer/VBoxContainer/DynamicGISet.disabled = false
		$ScrollContainer/VBoxContainer/SSAOSet.disabled = false
		$ScrollContainer/VBoxContainer/SSILSet.disabled = false
		$ScrollContainer/VBoxContainer/SSRSet.disabled = false
		$ScrollContainer/VBoxContainer/DynamicGISet.show()
		$ScrollContainer/VBoxContainer/SSAOSet.show()
		$ScrollContainer/VBoxContainer/SSILSet.show()
		$ScrollContainer/VBoxContainer/SSRSet.show()
