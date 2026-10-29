extends Node2D

var acabou: bool = false

@onready var jogador = $Jogador
@onready var laptop = $Laptop

@onready var texto_artista: Label = $HUD/VidaArtista
@onready var texto_laptop: Label = $HUD/VidaLaptop
@onready var mensagem: Label = $HUD/Mensagem


func _ready() -> void:
	jogador.vida_alterada.connect(_atualizar_artista)
	laptop.vida_alterada.connect(_atualizar_laptop)

	jogador.morreu.connect(
		_encerrar.bind("VOCÊ MORREU")
	)

	laptop.destruido.connect(
		_encerrar.bind("O LAPTOP FOI DESTRUIDO")
	)

	_atualizar_artista(jogador.vida_atual, jogador.vida_maxima)
	_atualizar_laptop(laptop.vida_atual, laptop.vida_maxima)

	mensagem.text = ""


func _atualizar_artista(atual: int, maxima: int) -> void:
	texto_artista.text = "Artista: %d/%d" % [atual, maxima]


func _atualizar_laptop(atual: int, maxima: int) -> void:
	texto_laptop.text = "Laptop: %d/%d" % [atual, maxima]


func _encerrar(motivo: String) -> void:
	if acabou:
		return

	acabou = true
	jogador.encerrar()
	get_tree().call_group("inimigos", "encerrar")

	mensagem.text = motivo + "\nPressione CTRL + R para reiniciar."


func _unhandled_input(event: InputEvent) -> void:
	if acabou and event.is_action_pressed("reiniciar"):
		get_tree().reload_current_scene()
