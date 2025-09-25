extends KinematicBody2D

# velocidad en px/s
export var velocidad = 700
# tiempo de vida en segundos
export var lifetime = 2.0

# dirección que le pasamos desde el tanque (Vector2)
var direccion = Vector2.ZERO

var _tiempo = 0.0

func _ready():
	# Conectamos señales para destruir el proyectil al chocar
	connect("area_entered", self, "_on_area_entered")
	connect("body_entered", self, "_on_body_entered")

func _process(delta):
	# Movimiento simple por posición (no physics)
	if direccion != Vector2.ZERO:
		position += direccion.normalized() * velocidad * delta
	else:
		# fallback: moverse en la dirección del rotation si no se pasó direccion
		position += Vector2(cos(rotation), sin(rotation)) * velocidad * delta

	_tiempo += delta
	if _tiempo >= lifetime:
		queue_free()

func _on_area_entered(area):
	# podes filtrar grupos si hace falta (ej: "enemigo"), ahora simplemente se destruye
	queue_free()

func _on_body_entered(body):
	queue_free()
