extends PathFollow3D
## Made by Yni, licensed under CC0.
class_name PathWalker

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress_ratio += 0.005 * delta
