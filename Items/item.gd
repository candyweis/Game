extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_pickup(body):
	$Blop1.play()
	await $Blop1.finished
	get_tree().queue_delete(self)
	
