extends Node2D

@export var cena_inimigo: PackedScene

var acabou: bool = false

@onready var jogador = $Jogador
@onready var laptop = $Laptop

@onready var texto_artista: Label = $HUD/VidaArtista
@onready var texto_laptop: Label = $HUD/VidaLaptop
@onready var texto_tempo: Label = $HUD/Tempo
@onready var mensagem: Label = $HUD/Mensagem

@onready var timer_spawn: Timer = $TimerSpawn
@onready var timer_partida: Timer = $TimerPartida
@onready var pontos_spawn: Node2D = $PontosSpawn


func _ready() -> void:
	jogador.vida_alterada.connect(_atualizar_artista)
	laptop.vida_alterada.connect(_atualizar_laptop)

	jogador.morreu.connect(_encerrar.bind("VOCÊ MORREU"))
	laptop.destruido.connect(
		_encerrar.bind("O LAPTOP FOI DESTRUIDO")
	)

	timer_spawn.timeout.connect(_gerar_inimigo)
	timer_partida.timeout.connect(_vencer)

	_atualizar_artista(jogador.vida_atual, jogador.vida_maxima)
	_atualizar_laptop(laptop.vida_atual, laptop.vida_maxima)
	mensagem.text = ""

	timer_partida.start()
	timer_spawn.start()


func _process(_delta: float) -> void:
	if acabou:
		return

	var segundos: int = ceili(timer_partida.time_left)
	texto_tempo.text = "Tempo: %ds" % segundos


func _gerar_inimigo() -> void:
	if acabou:
		return

	var ponto := pontos_spawn.get_children().pick_random() as Marker2D
	var novo_inimigo := cena_inimigo.instantiate() as Node2D

	novo_inimigo.position = to_local(ponto.global_position)
	add_child(novo_inimigo)


func _atualizar_artista(atual: int, maxima: int) -> void:
	texto_artista.text = "Artista: %d/%d" % [atual, maxima]


func _atualizar_laptop(atual: int, maxima: int) -> void:
	texto_laptop.text = "Laptop: %d/%d" % [atual, maxima]


func _vencer() -> void:
	if acabou:
		return

	texto_tempo.text = "Tempo: 0s"
	_encerrar("VOCÊ VENCEU!\nO laptop foi protegido.")


func _encerrar(motivo: String) -> void:
	if acabou:
		return

	acabou = true

	timer_spawn.stop()
	timer_partida.stop()

	jogador.encerrar()
	get_tree().call_group("inimigos", "encerrar")

	mensagem.text = motivo + "\nPressione R para reiniciar."


func _unhandled_input(event: InputEvent) -> void:
	if acabou and event.is_action_pressed("reiniciar"):
		get_tree().reload_current_scene()
