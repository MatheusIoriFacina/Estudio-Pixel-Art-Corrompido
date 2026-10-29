extends CharacterBody2D

signal vida_alterada(atual: int, maxima: int)
signal morreu

@export var velocidade: float = 80.0
@export var aceleracao: float = 800.0
@export var desaceleracao: float = 1200.0
@export var vida_maxima: int = 3
@export var dano_ataque: int = 1

var vida_atual: int
var encerrado: bool = false
var direcao_olhar := Vector2.DOWN
var recarga: float = 0.0
var tempo_efeito: float = 0.0
var invulneravel: float = 0.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var ataque: Node2D = $Ataque
@onready var alcance: ShapeCast2D = $Ataque/Alcance
@onready var rastro: Line2D = $Ataque/Rastro


func _ready() -> void:
	add_to_group("jogador")
	vida_atual = vida_maxima

	rastro.points = PackedVector2Array([
		Vector2(8, -8),
		Vector2(17, -5),
		Vector2(22, 0),
		Vector2(17, 5),
		Vector2(8, 8)
	])

	rastro.width = 2.0
	rastro.default_color = Color.CYAN
	ataque.hide()


func _physics_process(delta: float) -> void:
	if encerrado:
		return

	recarga = maxf(0.0, recarga - delta)
	tempo_efeito = maxf(0.0, tempo_efeito - delta)
	invulneravel = maxf(0.0, invulneravel - delta)

	ataque.visible = tempo_efeito > 0.0
	anim.modulate.a = 0.4 if invulneravel > 0.0 else 1.0

	var direcao := Input.get_vector(
		"mover_esquerda",
		"mover_direita",
		"mover_cima",
		"mover_baixo"
	)

	if direcao != Vector2.ZERO:
		if abs(direcao.x) > abs(direcao.y):
			direcao_olhar = Vector2.RIGHT if direcao.x > 0.0 else Vector2.LEFT
		else:
			direcao_olhar = Vector2.DOWN if direcao.y > 0.0 else Vector2.UP

	var taxa := aceleracao if direcao != Vector2.ZERO else desaceleracao
	velocity = velocity.move_toward(direcao * velocidade, taxa * delta)

	move_and_slide()
	_atualizar_animacao()

	if Input.is_action_just_pressed("atacar") and recarga <= 0.0:
		_atacar()


func _atualizar_animacao() -> void:
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


func _atacar() -> void:
	recarga = 0.35
	tempo_efeito = 0.14

	ataque.rotation = direcao_olhar.angle()
	ataque.show()
	alcance.force_shapecast_update()

	var atingidos: Array[Node2D] = []

	for i in range(alcance.get_collision_count()):
		var alvo := alcance.get_collider(i) as Node2D

		if not is_instance_valid(alvo) or alvo in atingidos:
			continue

		if alvo.is_in_group("inimigos") and _caminho_livre(alvo):
			atingidos.append(alvo)
			alvo.receber_dano(dano_ataque)


func _caminho_livre(alvo: Node2D) -> bool:
	var consulta := PhysicsRayQueryParameters2D.create(
		global_position + Vector2(0, -3),
		alvo.global_position + Vector2(0, -3),
		3
	)

	return get_world_2d().direct_space_state.intersect_ray(consulta).is_empty()


func receber_dano(quantidade: int) -> void:
	if encerrado or invulneravel > 0.0:
		return

	vida_atual = maxi(0, vida_atual - quantidade)
	invulneravel = 0.6
	vida_alterada.emit(vida_atual, vida_maxima)

	if vida_atual == 0:
		encerrar()
		morreu.emit()


func encerrar() -> void:
	encerrado = true
	velocity = Vector2.ZERO
	anim.stop()
	ataque.hide()
	anim.modulate.a = 1.0
