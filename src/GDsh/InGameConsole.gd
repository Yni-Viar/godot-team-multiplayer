extends Control


## Control with console log and prompt
##
## You can use it for creating additional terminals, but usually it invokes by GDsh singleton
##
## @tutorial(How to use plugin): https://github.com/USBashka/console-godot-plugin/blob/main/README.md


var history = []
var current_command = 0

@onready var log = $VBox/Log
@onready var tip = $Tooltip
@onready var prompt = $VBox/HBox/Prompt

func _ready():
	prompt.grab_focus()


func send_command(text: String):
	history.append(text)
	current_command = history.size()
	var list = text.strip_edges().split(" ")
	log.text += ("> [color=yellow]" + list[0] + "[/color] [color=gray]" +
				" ".join(list.slice(1)) + "[/color]\n")
	var command = list[0]
	var args = list.slice(1)
	var result = GDsh.call_command(command, args)
	if result:
		log.text += str(result) + "\n"


func _on_submit_pressed():
	prompt.grab_focus()
	if prompt.text:
		send_command(prompt.text)
		prompt.text = ""
	else:
		var TW = create_tween().set_trans(Tween.TRANS_SINE)
		TW.tween_property(prompt, "modulate", Color.RED, 0.1)
		TW.tween_property(prompt, "modulate", Color.WHITE, 0.1)
		TW.play()


func _on_prompt_gui_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER:
			get_tree().root.set_input_as_handled()
			_on_submit_pressed()
		elif event.keycode == KEY_UP:
			get_tree().root.set_input_as_handled()
			if current_command > 0:
				current_command -= 1
				prompt.text = history[current_command]
		elif event.keycode == KEY_DOWN:
			get_tree().root.set_input_as_handled()
			if current_command < history.size():
				current_command += 1
				if current_command < history.size():
					prompt.text = history[current_command]
				else:
					prompt.text = ""


func _on_log_meta_clicked(meta: String):
	var protocol = meta.split("://")[0]
	print(protocol)
	match protocol:
		"command": send_command(meta.trim_prefix("command://"))
		_: OS.shell_open(meta)


func _on_log_meta_hover_started(meta):
	tip.text = meta
	tip.global_position = get_viewport().get_mouse_position() + Vector2(16, 16)
	tip.show()


func _on_log_meta_hover_ended(meta):
	tip.hide()
	tip.text = ""


func _on_log_focus_entered():
	prompt.grab_focus()
