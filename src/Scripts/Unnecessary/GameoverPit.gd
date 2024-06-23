extends Area3D
## Not necessary to use.
## This script is used for changing player's class when entering area.
## Maybe useful, for punching out players, who left the gameplay area...
## Made by Yni, licensed under CC0.


# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_body_entered(body):
	if body is PlayerScript:
		body.rpc("health_manage", -16777216, 0, "You left the game map")
