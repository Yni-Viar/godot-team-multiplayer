extends Control
## Main menu script.
## Made by Yni, licensed under CC0. 

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.playing = true
	## check stage of development and use.
	match Globals.current_stage:
		Globals.Stages.release:
			get_node("Background").texture = load("res://Assets/Menu/MainMenuBackground.png")
		Globals.Stages.testing:
			get_node("Background").texture = load("res://Assets/Menu/MainMenuBackgroundTesting.png")
		_:
			get_node("Background").texture = load("res://Assets/Menu/MainMenuBackgroundIndev.png")
	
	if OS.get_name() != "Android":
		get_window().size = Settings.window_size
		print(get_window().size)
	
	AudioServer.set_bus_volume_db(0, linear_to_db(Settings.sound))
	if Settings.sound < 0.01:
		AudioServer.set_bus_mute(2, true)
	elif Settings.sound >= 0.01 && AudioServer.is_bus_mute(0):
		AudioServer.set_bus_mute(2, false)
	
	AudioServer.set_bus_volume_db(1, linear_to_db(Settings.music))
	if Settings.sound < 0.01: 
		AudioServer.set_bus_mute(1, true)
	elif Settings.sound >= 0.01 && AudioServer.is_bus_mute(1):
		AudioServer.set_bus_mute(1, false)
	
	if Settings.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	TranslationServer.set_locale(Settings.language)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_settings_pressed():
	$Settings.show()


func _on_credits_pressed():
	$CreditsPanel.show()


func _on_exit_pressed():
	get_tree().quit()


func _on_credits_back_pressed():
	$CreditsPanel.hide()


func _on_mods_pressed():
	var wnd = load("res://ModLoaderUI/mods_window.tscn").instantiate()
	add_child(wnd)
