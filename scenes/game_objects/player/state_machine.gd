extends Node

@export var inital_state: State

var current_state: State
var states: Dictionary = {}


func _ready() -> void:
	# DÜZELTME: Bu satır, sahibi olan Player'ın kendi _ready()
	# fonksiyonunu bitirmesini ve tamamen hazır olmasını bekler.
	await owner.ready
	
	# Altındaki bütün state node'larını adlarıyla bir sözlüğe ekliyoruz
	for child in get_children():
		if child is State:
			states[child.name] = child
	
	# Başlangıç durumu atanmışsa, oyunu o durumla başlat
	if inital_state:
		current_state = inital_state
		current_state.enter()


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func transition_to(state_name: String, payload: Dictionary = {}) -> void:
	# Geçmek istediğimiz durum mevcut mu diye kontrol et.
	if not states.has(state_name):
		return
	
	# Zaten o durumda isek bir şey yapma.
	if current_state and current_state.name == state_name:
		return
	
	# Mevcut durumdan çıkış fonksiyonunu çağır.
	if current_state:
		current_state.exit()
	
	# Yeni durumu aktif durum olarak ata.
	current_state = states[state_name]
	
	# Yeni durumun giriş fonksiyonunu çağır.
	# 'payload' ile yeni duruma ekstra bilgi gönderebiliriz (örneğin, "ölüm animasyonunu oyna").
	current_state.enter(payload)
