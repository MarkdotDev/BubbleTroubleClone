extends CharacterBody2D

const SPEED = 300.0
var can_shoot: bool = true
var invulnerable: bool = false
@onready var shoot_timer: Timer = $ShootTimer
var arrow_scene = preload("res://arrow.tscn")

func _ready() -> void:
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED

	if direction != 0:
		$Sprite2D.flip_h = direction < 0

	move_and_slide()

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("bubbles") and not invulnerable:
			hit_by_bubble()

	var viewport_rect = get_viewport_rect().size
	position.x = clamp(position.x, 0, viewport_rect.x)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and can_shoot:
		shoot()

func hit_by_bubble() -> void:
	GameManager.lose_life()
	if GameManager.lives > 0:
		become_invulnerable()

func become_invulnerable() -> void:
	invulnerable = true
	modulate.a = 0.5
	var timer = get_tree().create_timer(2.0)
	timer.timeout.connect(_on_invulnerability_timeout)

func _on_invulnerability_timeout() -> void:
	invulnerable = false
	modulate.a = 1.0

func shoot() -> void:
	var arrow = arrow_scene.instantiate()
	arrow.position = global_position + Vector2(0, -20)
	get_parent().add_child(arrow)
	
	can_shoot = false
	shoot_timer.start()

func _on_shoot_timer_timeout():
	can_shoot = true
