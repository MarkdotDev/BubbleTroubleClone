extends Node

signal score_updated(new_score)
signal lives_updated(lives_left)
signal game_over

var score: int = 0
var lives: int = 3
var bubbles_remaining: int = 0
var game_active: bool = true

func _ready() -> void:
	reset_game()

func reset_game() -> void:
	score = 0
	lives = 3
	bubbles_remaining = 0
	game_active = true
	emit_signal("score_updated", score)
	emit_signal("lives_updated", lives)

func lose_life() -> void:
	lives -= 1
	emit_signal("lives_updated", lives)

	if lives <= 0:
		game_active = false
		emit_signal("game_over")

func on_bubble_pop(size: int) -> void:
	if not game_active:
		return

	score += size * 100
	emit_signal("score_updated", score)

func register_bubble() -> void:
	bubbles_remaining += 1

func deregister_bubble() -> void:
	bubbles_remaining -= 1
	if bubbles_remaining <= 0 and game_active:
		game_active = false
		emit_signal("game_over")
