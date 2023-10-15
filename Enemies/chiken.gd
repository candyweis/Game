extends CharacterBody2D


@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
var direction := -1
var spawn_position : Vector2

const SPEED = 30.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	velocity = Vector2.ZERO
	spawn_position = position
	if randf() < 0.5:
		direction = -1
	else:
		direction = 1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_wall():
		direction = -direction

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
		anim.flip_h = false
	elif velocity.x > 0:
		anim.flip_h = true
	if velocity.x:
		anim.play("Run")
	else:
		anim.play("Idle")


func on_death():
	position = spawn_position
	#queue_free()
