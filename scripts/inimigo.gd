extends CharacterBody2D

enum InimigoState { chase, hurt, death, stopped }

@export var velocidade: float = 35.0
@export var vida_maxima: int = 2
@export var grupo_alvo: String = "laptop"
@export var alcance_ataque: float = 16.0
@export var tempo_hurt: float = 0.12

var vida_atual: int
var status: InimigoState
var recarga: float = 0.0
var tempo_no_hurt: float = 0.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var agente: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:
	add_to_group("inimigos")
	vida_atual = vida_maxima
	go_to_chase_state()


func _physics_process(delta: float) -> void:
	if status in [InimigoState.death, InimigoState.stopped]:
		return

	recarga = maxf(0.0, recarga - delta)

	match status:
		InimigoState.chase:
			chase_state()
		InimigoState.hurt:
			hurt_state(delta)

	if status in [InimigoState.death, InimigoState.stopped]:
		return

	move_and_slide()

	if status == InimigoState.chase:
		_atualizar_animacao()


func go_to_chase_state() -> void:
	status = InimigoState.chase
	anim.modulate = Color.WHITE

# Referência: máquina de estados da Aula 06 de Jogos Digitais II.
# Adaptação para top-down com auxílio do ChatGPT.
func chase_state() -> void:
	velocity = Vector2.ZERO

	var alvo := get_tree().get_first_node_in_group(grupo_alvo) as Node2D

	if not is_instance_valid(alvo):
		return

	var jogador := get_tree().get_first_node_in_group("jogador") as Node2D

	if is_instance_valid(jogador) and recarga <= 0.0:
		if global_position.distance_to(jogador.global_position) <= alcance_ataque:
			if _caminho_livre(jogador):
				recarga = 0.9
				jogador.receber_dano(1)

				if status != InimigoState.chase:
					return

	agente.target_position = alvo.global_position

	if not agente.is_navigation_finished():
		var proximo := agente.get_next_path_position()
		velocity = global_position.direction_to(proximo) * velocidade


func go_to_hurt_state() -> void:
	status = InimigoState.hurt
	tempo_no_hurt = 0.0
	velocity = Vector2.ZERO
	anim.stop()
	anim.modulate = Color.SALMON


func hurt_state(delta: float) -> void:
	tempo_no_hurt += delta

	if tempo_no_hurt >= tempo_hurt:
		go_to_chase_state()
		return


func go_to_death_state() -> void:
	status = InimigoState.death
	velocity = Vector2.ZERO
	anim.stop()
	set_physics_process(false)
	hide()
	queue_free()


func go_to_stopped_state() -> void:
	status = InimigoState.stopped
	velocity = Vector2.ZERO
	anim.stop()
	anim.modulate = Color.WHITE
	set_physics_process(false)


func receber_dano(quantidade: int) -> void:
	if status != InimigoState.chase:
		return

	vida_atual = maxi(0, vida_atual - quantidade)

	if vida_atual == 0:
		go_to_death_state()
		return

	go_to_hurt_state()


func consumir() -> bool:
	if status in [InimigoState.death, InimigoState.stopped]:
		return false

	go_to_death_state()
	return true


func encerrar() -> void:
	if status in [InimigoState.death, InimigoState.stopped]:
		return

	go_to_stopped_state()


func _atualizar_animacao() -> void:
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
