extends Area2D

enum item_type {ITEM_FRUIT, ITEM_KEY, ITEM_D_JUMP, ITEM_BONUS}
@export var type : item_type

@export var points : int = 1 
var is_picked : bool = false
#onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_pickup(body):
	if is_picked:
		return
	is_picked = true
	var tween1 = get_tree().create_tween().set_parallel(true)
	tween1.tween_property($".", "position:y", position.y -20, 1)
	tween1.tween_property($AnimatedSprite2D, "self_modulate:a", 0.0, 1)
	
	
	
	GlovalVars.score += points
	if (GlovalVars.score > GlovalVars.hi_score):
		GlovalVars.hi_score = GlovalVars.score
		$OnRecord.play()
		await $OnRecord.finished
	else:
		$Blop1.play()
		await $Blop1.finished
	await tween1.finished
	match type:
		item_type.ITEM_FRUIT:
			pass
		item_type.ITEM_KEY:
			body.has_key = true
		item_type.ITEM_BONUS:
			pass
		item_type.ITEM_D_JUMP:
			body.has_double_jump = true
		
	#get_tree().queue_delete(self)
	queue_free()


	


func _on_timer_timeout(body) -> void:
	body.has_double_jump = false
