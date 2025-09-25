extends KinematicBody2D

var movimiento = Vector2()
var velocidad = 40

func _ready():
	randomize()
	$Timer.start()

func _physics_process(delta):
	move_and_slide(movimiento * velocidad)

var arriba = Vector2(0,-1)
var abajo = Vector2(0,1)
var derecha = Vector2(1,0)
var izquierda = Vector2(-1,0)

func arriba():
	Vector2(0,-1)
	$Sprite.spl

func obtener_dierccion_random():
	var rango = randi() % 4
	match rango:
		0: return arriba
		1: return abajo
		2: return derecha
		3: return izquierda

func _on_Timer_timeout():
	movimiento = obtener_dierccion_random()
	var tiempo_de_cambios = randf() * 1.5 + 0.5
	$Timer.wait_time = tiempo_de_cambios
	$Timer.start()

func _on_Sprite_frame_changed():
	pass # Replace with function body.
