extends Node2D

signal vida_alterada(atual: int, maxima: int)
signal destruido

@export var vida_maxima: int = 5

var vida_atual: int


func _ready() -> void:
	add_to_group("laptop")
	vida_atual = vida_maxima
	$AreaDano.body_entered.connect(_ao_receber_contato)


func _ao_receber_contato(corpo: Node2D) -> void:
	if vida_atual <= 0 or not corpo.is_in_group("inimigos"):
		return

	if corpo.consumir():
		receber_dano(1)


func receber_dano(quantidade: int) -> void:
	if vida_atual <= 0:
		return

	vida_atual = maxi(0, vida_atual - quantidade)
	vida_alterada.emit(vida_atual, vida_maxima)

	if vida_atual == 0:
		$Sprite2D.modulate = Color.DIM_GRAY
		destruido.emit()
