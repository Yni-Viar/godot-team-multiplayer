extends Node


## GDsh console singleton
##
## This singleton used for executing, adding or deleting commands.[br]
## [b]Built-in commands:[/b][br]
## [code]help[/code][br]
## [code]echo[/code][br]
## [code]cat[/code][br]
## [code]gdfetch[/code]
## [br][br]
##
## Use [method add_command] to add new commands and [method remove_command] to delete them
##
## @tutorial(How to use plugin): https://github.com/USBashka/console-godot-plugin/blob/main/README.md


## Version of GDsh
var version = {
	"major": 0,
	"minor": 0,
	"patch": 3,
	"status": "",
	"build": "",
	"year": 2022
}

## The list of commands that can be executed along with associated callables
var commands = {
	"help": {
		"callable": help,
		"short_desc": "Print the list of available commands",
		"description": "help <command> for specific help"
	},
	"echo": {
		"callable": echo,
		"short_desc": "Print given input",
		"description": "Just prints given input"
	},
	"gdfetch": {
		"callable": gdfetch,
		"short_desc": "Display system information",
		"description": "Analogue of neofetch but shows Engine's stuff"
	},
	"clear": {
		"callable": clear,
		"short_desc": "Clears console log",
		"description": ""
	}
}

## Console window
var console: PackedScene = load("res://GDsh/InGameConsole.tscn")

func _ready():
	version.merge({"string": "{major}.{minor}.{patch}".format(version)})


## Calls command with given args if exists
func call_command(command: String, args: Array = []):
	if command in commands:
		return commands[command]["callable"].call(args)
	else:
		return "No such command \"%s\""%command


## Adds command
## [br][br]
## [param name] is command itself[br]
## [param function] is associated callable ([b]MUST[/b] have [param args] [Array] parameter)[br]
## [param short_desc] is description showed in commands list[br]
## [param description] is full description that showed when [code]help <name>[/code] used
func add_command(name: String, function: Callable, short_desc = "", description = ""):
	commands[name] = {
		"callable": function,
		"short_desc": short_desc,
		"description": description
	}

## Returns [code]true[/code] if given command exists
func has_command(name: String) -> bool:
	return name in commands

## Removes command. Returns [code]true[/code] if success
func remove_command(name: String) -> bool:
	return commands.erase(name)

## Returns dictionary with version information
func get_version_info():
	return version


## Built-in command
func help(args: Array):
	var r = ""
	if args:
		for command in args:
			if command in commands:
				r += command + " [color=gray]" + commands[command]["short_desc"] + "[/color]\n"
				r += "[color=gray]" + commands[command]["description"] + "[/color]\n"
			else:
				r += "No such command \"%s\""%command
	else:
		r += "[ul]"
		for command in commands:
			r += "[url=command://help %s]"%command + command + "[/url] [color=gray]" + commands[command]["short_desc"] + "[/color]\n"
		r += "[/ul]"
	return r

## Built-in command
func echo(args: Array):
	return " ".join(args)

## Built-in command
func gdfetch(args: Array):
	var r = ""
	var logo_mini = """     _    _
_  _| |__| |_  _
\\\\/          \\//
|  _        _  |
| (o)  ()  (o) |
l_    ____    _i
| |__/    \\__| |
\\_            _/
  `--______--`"""
	var username = OS.get_environment("USERNAME") + "@" + ProjectSettings.get_setting("application/config/name")
	var uptime = Time.get_ticks_msec()/1000
	var uptime_string = ""
	if uptime > 3599:
		uptime_string += str(floor(uptime/3600)) + " hours "
	if uptime > 59:
		uptime_string += str(floor(uptime%3600/60)) + " minutes "
	uptime_string += str(uptime%60) + " seconds"
	var stats = {
		"OS": OS.get_name(),
		"Host": OS.get_model_name(),
		"Engine": "Godot {string} ({year})".format(Engine.get_version_info()),
		"Uptime": uptime_string,
		"Shell": "GDsh {string} ({year})".format(GDsh.get_version_info()),
		"Resolution": str(get_tree().root.get_visible_rect().size),
		"CPU": OS.get_processor_name(),
		"GPU": RenderingServer.get_video_adapter_name(),
		"Memory": String.humanize_size(OS.get_static_memory_usage()),
		"Video Memory": String.humanize_size(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)),
		
	}
	var logo_lines = logo_mini.split("\n")
	for line in stats.size() + 2:
		if line < logo_lines.size():
			r += "   [color=#478CBF]" + logo_lines[line].rpad(19) + "[/color]"
		else:
			r += " ".repeat(22)
		match line:
			0: r += "[b][color=#99aa99]" + username + "[/color][/b]"
			1: r += "-".repeat(username.length())
			_: r += "[b][color=#aaaa99]" + stats.keys()[line-2] + "[/color][/b]: " + stats[stats.keys()[line-2]]
		r += "\n"
	return r

## Built-in command
func clear(args: Array):
	console.log.text = ""
