extends KinematicBody2D

var movimiento = Vector2()
var velocidad = 80

func _ready():
	randomize()
	$Timer.start()



func _physics_process(delta):
	move_and_slide(movimiento * velocidad)


var arriba = Vector2(0,-1)
var abajo = Vector2(0,1)
var derecha = Vector2(1,0)
var izquierda = Vector2(-1,0)
var arriba_a_la_derecha = Vector2(1,-1)
var arriba_a_la_izquierda = Vector2(-1,-1)
var abajo_a_la_derecha = Vector2(1,1)
var abajo_a_la_izquierda = Vector2(-1,1)

func obtener_dierccion_random():
	var rango = randi() % 8
	match rango:
		0: return arriba
		1: return abajo
		2: return derecha
		3: return izquierda
		4: return arriba_a_la_derecha
		5: return arriba_a_la_izquierda
		6: return abajo_a_la_derecha
		7: return abajo_a_la_izquierda


func _on_Timer_timeout():
	movimiento = obtener_dierccion_random()
	rotar()
	var tiempo_de_cambios = randf() * 4 + 0.5
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
	elif movimiento == arriba_a_la_derecha:
		$NPC.rotation_degrees = 45
	elif movimiento == abajo_a_la_derecha:
		$NPC.rotation_degrees = 135
	elif movimiento == abajo_a_la_izquierda:
		$NPC.rotation_degrees = 225
	elif movimiento == arriba_a_la_izquierda:
		$NPC.rotation_degrees = 315

func _on_Sprite_frame_changed():
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if body.is_in_group("obstaculos y limites"):
		movimiento = obtener_dierccion_random()
		rotar()
	pass # Replace with function body.
