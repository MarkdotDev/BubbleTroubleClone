extends Area2D

const SPEED = 400.0
var direction = Vector2.UP

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	add_to_group("arrows")

func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta

	if position.y < -50:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("bubbles"):
		body.split()
		queue_free()
