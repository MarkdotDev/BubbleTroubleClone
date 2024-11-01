extends Node2D

@onready var lives_label: Label = $UI/LivesLabel
@onready var score_label: Label = $UI/ScoreLabel
@onready var game_over_label: Label = $UI/GameOverLabel

func _ready() -> void:
	setup_ui()
	var viewport_size = get_viewport_rect().size
	$Floor.position = Vector2(viewport_size.x / 2, viewport_size.y)
	$Player.position = Vector2(viewport_size.x / 2, viewport_size.y - 50)
	setup_walls()
	GameManager.score_updated.connect(_on_score_updated)
	GameManager.game_over.connect(_on_game_over)
	GameManager.lives_updated.connect(_on_lives_updated)
	GameManager.reset_game()
	spawn_initial_bubbles()

func setup_ui() -> void:
	_on_score_updated(0)
	_on_lives_updated(3)
	game_over_label.hide()

func setup_walls() -> void:
	var viewport_size = get_viewport_rect().size

	var left_wall = StaticBody2D.new()
	var left_wall_shape = CollisionShape2D.new()
	var left_wall_rect = RectangleShape2D.new()
	left_wall_rect.size = Vector2(20, viewport_size.y)
	left_wall_shape.shape = left_wall_rect
	left_wall.add_child(left_wall_shape)
	left_wall.position = Vector2(0, viewport_size.y / 2)
	add_child(left_wall)
	
	var right_wall = StaticBody2D.new()
	var right_wall_shape = CollisionShape2D.new()
	var right_wall_rect = RectangleShape2D.new()
	right_wall_rect.size = Vector2(20, viewport_size.y)
	right_wall_shape.shape = right_wall_rect
	right_wall.add_child(right_wall_shape)
	right_wall.position = Vector2(viewport_size.x, viewport_size.y / 2)
	add_child(right_wall)

func spawn_initial_bubbles() -> void:
	GameManager.bubbles_remaining = 1
	for i in range(GameManager.bubbles_remaining):
		var bubble = load("res://bubble.tscn").instantiate()
		bubble.position = Vector2(get_viewport_rect().size.x / 2, 100)
		bubble.linear_velocity = Vector2(200, 0)
		add_child(bubble)

func _on_score_updated(new_score: int) -> void:
	score_label.text = "Score: %d" % new_score

func _on_lives_updated(lives_left: int) -> void:
	lives_label.text = "Lives: %d" % lives_left

func _on_game_over() -> void:
	game_over_label.show()
	var timer = get_tree().create_timer(3.0)
	timer.timeout.connect(GameManager.reset_game)
