extends KinematicBody2D

var movimiento = Vector2()
var velocidad = 50

func _ready():
	randomize()
	$Timer.start()

func _physics_process(delta):
	move_and_slide(movimiento * velocidad)

var arriba = Vector2(0,-1)
var abajo = Vector2(0,1)
var derecha = Vector2(1,0)
var izquierda = Vector2(-1,0)

func obtener_dierccion_random():
	var rango = randi() % 4
	match rango:
		0: return arriba
		1: return abajo
		2: return derecha
		3: return izquierda


func _on_Timer_timeout():
	movimiento = obtener_dierccion_random()
	rotar()
	var tiempo_de_cambios = randf() * 1 + 0.5
	$Timer.wait_time = tiempo_de_cambios
	$Timer.start()

func rotar():
	if movimiento == arriba:
		$NPC.rotation_degrees = 0
	elif movimiento == abajo:
		$NPC.rotation_degrees = 180
	elif movimiento == derecha:
		$NPC.rotation_degrees = 90
	elif movimiento == izquierda:
		$NPC.rotation_degrees = 270

func _on_Sprite_frame_changed():
	pass # Replace with function body.
