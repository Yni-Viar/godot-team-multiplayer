extends BasePlayerScript
## Example implementation of human system.
## Made by Yni, licensed under MIT license.
class_name HumanPlayerScript

@export var enable_blinking: bool = false
@export var blink_timer_default: float = 5.2
@export var enable_items: bool = false
var blink_timer: float = blink_timer_default
var is_blinking: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().get_parent().is_multiplayer_authority():
		get_node(armature_name).hide()
		get_parent().get_parent().get_node("PlayerHead/PlayerRecoil/PlayerHand").show()
	get_parent().get_parent().set_collision_mask_value(3, true)
	on_start()

func on_start():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# for blink-based games
	if enable_blinking && get_parent().get_parent().is_multiplayer_authority():
		if blink_timer > 0:
			blink_timer -= delta
		else:
			is_blinking = true
			await get_tree().create_timer(0.3).timeout
			blink_timer = blink_timer_default
			is_blinking = false
	if get_node_or_null("AnimationTree") != null:
		get_node("AnimationTree").active = true
		if (Input.is_action_pressed("move_forward") || Input.is_action_pressed("move_backward") || Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left")) && get_parent().get_parent().can_move:
			if Input.is_action_pressed("move_sprint"):
				if !get_node("AnimationTree").get("parameters/state_machine/blend_amount") + 0.00001 > 1:
					rpc("set_state", "state_machine", "blend_amount", lerp(get_node("AnimationTree").get("parameters/state_machine/blend_amount"), 1.0, delta * get_parent().get_parent().speed * 2))
			else:
				if !get_node("AnimationTree").get("parameters/state_machine/blend_amount") + 0.00001 > 0:
					rpc("set_state", "state_machine", "blend_amount", lerp(get_node("AnimationTree").get("parameters/state_machine/blend_amount"), 0.0, delta * get_parent().get_parent().speed * 2))
		else:
			if !get_node("AnimationTree").get("parameters/state_machine/blend_amount") - 0.00001 < -1:
				rpc("set_state", "state_machine", "blend_amount", lerp(get_node("AnimationTree").get("parameters/state_machine/blend_amount"), -1.0, delta * get_parent().get_parent().speed * 2))
		#if !get_parent().get_parent().using_item.is_empty():
			#if !get_node("AnimationTree").get("parameters/items_blend/blend_amount")+ 0.00001 > 1:
				#rpc("set_state", "items_blend", "blend_amount", 1)
		#else:
			#if !get_node("AnimationTree").get("parameters/items_blend/blend_amount") - 0.00001 < 0:
				#rpc("set_state", "items_blend", "blend_amount", 0)
	on_update(delta)

func on_update(delta):
	pass

## Set animation to an entity via Animation Tree.
@rpc("any_peer")
func set_state(animation_name: String, action_name: String, amount):
	get_node("AnimationTree").set("parameters/" + animation_name + "/" + action_name, amount)
