extends MultiplayerSynchronizer
## Used for MIT-licensed tutorials

var direction: Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().is_multiplayer_authority():
		direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
