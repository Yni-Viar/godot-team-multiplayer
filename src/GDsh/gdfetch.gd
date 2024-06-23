extends Node


## A script that extends %BASE% functionality
##
## The description of the script, what it can do, and any further detail.
##
## @tutorial(Tutorial1): https://github.com/USBashka


var ascii_art = """
"""

var stats = {
	"OS": OS.get_name(),
	"Host": OS.get_model_name(),
	"Engine": "Godot Engine {string} ({year})".format(Engine.get_version_info().string),
	"Uptime": str(Time.get_ticks_msec()/1000),
	"Shell": "GDsh {string} ({year})".format(GDsh.get_version_info().string),
	"Resolution": get_tree().root.get_visible_rect().size,
	"CPU": OS.get_processor_name(),
	"GPU": RenderingServer.get_video_adapter_name(),
	"Memory": str(OS.get_static_memory_usage()),
	"Video Memory": str(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED))
}

func exec(args: Array[String]):
	var r = ""
	for i in stats:
		r += i + "\t" + stats[i] + "\n"
	return r
