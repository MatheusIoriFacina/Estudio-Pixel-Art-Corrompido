extends CharacterBody2D

@export var velocidade: float = 80.0
@export var aceleracao: float = 800.0
@export var desaceleracao: float = 1200.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	var direcao := Input.get_vector(
		"mover_esquerda",
		"mover_direita",
		"mover_cima",
		"mover_baixo"
	)

	var taxa := aceleracao if direcao != Vector2.ZERO else desaceleracao
	var velocidade_desejada := direcao * velocidade

	velocity = velocity.move_toward(
		velocidade_desejada,
		taxa * delta
	)

	move_and_slide()

	var movimento := get_real_velocity()

	if movimento.length() < 1.0:
		anim.stop()
		return

	if abs(movimento.x) > abs(movimento.y):
		anim.play("direita" if movimento.x > 0.0 else "esquerda")
	else:
		anim.play("baixo" if movimento.y > 0.0 else "cima")

	anim.speed_scale = clampf(
		movimento.length() / velocidade,
		0.5,
		1.0
	)
