extends CharacterBody2D

@export var velocidade: float = 35.0
@export var vida_maxima: int = 2
@export var distancia_perseguicao: float = 64.0
@export var alcance_ataque: float = 16.0

var vida_atual: int
var ativo: bool = true
var recarga: float = 0.0
var tempo_dano: float = 0.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	add_to_group("inimigos")
	vida_atual = vida_maxima


func _physics_process(delta: float) -> void:
	if not ativo:
		return

	recarga = maxf(0.0, recarga - delta)
	tempo_dano = maxf(0.0, tempo_dano - delta)

	anim.modulate = Color.SALMON if tempo_dano > 0.0 else Color.WHITE

	var jogador := get_tree().get_first_node_in_group("jogador") as Node2D
	var alvo := get_tree().get_first_node_in_group("laptop") as Node2D

	if is_instance_valid(jogador):
		if global_position.distance_to(jogador.global_position) <= distancia_perseguicao:
			if _caminho_livre(jogador):
				alvo = jogador

	if not is_instance_valid(alvo):
		velocity = Vector2.ZERO
		anim.stop()
		return

	if alvo == jogador and global_position.distance_to(alvo.global_position) <= alcance_ataque:
		velocity = Vector2.ZERO
		anim.stop()

		if recarga <= 0.0 and _caminho_livre(alvo):
			recarga = 0.9
			alvo.receber_dano(1)

		return

	velocity = global_position.direction_to(alvo.global_position) * velocidade
	move_and_slide()

	var movimento := get_real_velocity()

	if movimento.length() < 1.0:
		anim.stop()
	elif abs(movimento.x) > abs(movimento.y):
		anim.play("direita" if movimento.x > 0.0 else "esquerda")
	else:
		anim.play("baixo" if movimento.y > 0.0 else "cima")


func _caminho_livre(alvo: Node2D) -> bool:
	var consulta := PhysicsRayQueryParameters2D.create(
		global_position + Vector2(0, -3),
		alvo.global_position + Vector2(0, -3),
		3
	)

	return get_world_2d().direct_space_state.intersect_ray(consulta).is_empty()


func receber_dano(quantidade: int) -> void:
	if not ativo:
		return

	vida_atual = maxi(0, vida_atual - quantidade)
	tempo_dano = 0.12

	if vida_atual == 0:
		consumir()


func consumir() -> bool:
	if not ativo:
		return false

	encerrar()
	hide()
	queue_free()
	return true


func encerrar() -> void:
	ativo = false
	velocity = Vector2.ZERO
	anim.stop()
