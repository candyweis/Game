extends CharacterBody2D

@export var tilemap : TileMap

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var has_key : bool = false
var has_double_jump : bool = false
var can_double_jump : bool = false
var healt = 100
var syncPos = Vector2(0,0)
@onready var cam = $Camera2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
#	cam.enabled = is_multiplayer_authority()
	var r = tilemap.get_used_rect()
	var vp = tilemap.get_viewport_rect()
	var qs = tilemap.cell_quadrant_size
	$Camera2D.limit_left = r.position.x * qs
	$Camera2D.limit_top = r.position.y * qs
	$Camera2D.limit_right = $Camera2D.limit_left + r.size.x * qs
	$Camera2D.limit_bottom = $Camera2D.limit_top + r.size.y * qs
	$Camera2D.limit_top = min($Camera2D.limit_top, $Camera2D.limit_bottom - vp.size.y)

func _enter_tree():
	set_multiplayer_authority(name.to_int())
	

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
	#	if is_multiplayer_authority():
			# Add the gravity.
		if !is_on_floor():
			velocity.y += gravity * delta
			syncPos = global_position
			# Handle Jump.
		if Input.is_action_just_pressed("ui_accept"):
			if is_on_floor():
				can_double_jump = true
				velocity.y = JUMP_VELOCITY
			if not is_on_floor() and has_double_jump and can_double_jump:
				can_double_jump = false
				velocity.y = JUMP_VELOCITY * 0.75

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		update_animation()
		move_and_slide()
		if position.y > 480:
			on_death()
	else:
		if !is_on_floor():
			velocity.y += gravity * delta

			# Handle Jump.
		if Input.is_action_just_pressed("ui_accept"):
			if is_on_floor():
				can_double_jump = true
				velocity.y = JUMP_VELOCITY
			if not is_on_floor() and has_double_jump and can_double_jump:
				can_double_jump = false
				velocity.y = JUMP_VELOCITY * 0.75

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		update_animation()
		move_and_slide()
		if position.y > 480:
			on_death()
func update_animation():
	if velocity.x < 0:
		anim.flip_h = true
	elif velocity.x > 0:
		anim.flip_h = false
		
	if velocity.x:
		anim.play("Run")
	else:
		anim.play("Idle")
		
	if velocity.y < 0:
		anim.play("Jump")
	elif velocity.y > 0:
		anim.play("Fall")
		
func on_death():
	get_tree().change_scene_to_file("res://menus/GameOver.tscn")
	self.queue_free()
	


func _on_pick_up_area_area_entered(area: Area2D) -> void:
	if area.has_method("on_pickup"):
		area.on_pickup(self)
