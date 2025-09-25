extends KinematicBody2D

export var velocidad = 220
export var velocidad_rotacion = 9.9
# escena del proyectil (arrastrala desde el FileSystem al inspector o deja vacío y usá preload)
export(PackedScene) var escena_proyectil
# tiempo mínimo entre disparos (segundos)
export var fire_rate = 0.25

var tamanio_pantalla = Vector2(1920, 1080)

# Dirección de movimiento actual
var direccion = Vector2.ZERO

# Tamaño del tanque
var mitad_ancho = 0
var mitad_alto = 0

# control de cooldown para disparos
var _fire_cooldown = 0.0

func _ready():
	# Obtener tamaño del sprite
	var sprite = $Sprite
	if sprite and sprite.texture:
		mitad_ancho = sprite.texture.get_size().x / 2
		mitad_alto = sprite.texture.get_size().y / 2
	else:
		# valores por defecto si no hay sprite
		mitad_ancho = 16
		mitad_alto = 16

	# Asegurar que el tanque empiece dentro de los límites
	position.x = clamp(position.x, mitad_ancho, tamanio_pantalla.x - mitad_ancho)
	position.y = clamp(position.y, mitad_alto, tamanio_pantalla.y - mitad_alto)

func _physics_process(delta):
	# actualizar cooldown
	if _fire_cooldown > 0.0:
		_fire_cooldown -= delta
	mover()
	rotar(delta)
	move_and_slide(direccion * velocidad)



	# Detectar teclas (solo 4 direcciones)
func mover():
	if Input.is_action_pressed("ui_right"):
		direccion = Vector2.RIGHT
	elif Input.is_action_pressed("ui_left"):
		direccion = Vector2.LEFT
	elif Input.is_action_pressed("ui_down"):
		direccion = Vector2.DOWN
	elif Input.is_action_pressed("ui_up"):
		direccion = Vector2.UP
	if  (Input.is_action_just_released("ui_right") or 
			Input.is_action_just_released("ui_left") or 
			Input.is_action_just_released("ui_up") or 
			Input.is_action_just_released("ui_down")):
		direccion = Vector2.ZERO

func rotar(delta):
	if direccion != Vector2.ZERO: #direccion = nueva_direccion
		var angulo_deseado = direccion.angle()
		rotation = lerp_angle(rotation, angulo_deseado, velocidad_rotacion * delta)


	# Disparo con click izquierdo (acción "shoot")
	if Input.is_action_just_pressed("shoot") and _fire_cooldown <= 0.0:
		_disparar()

	# Limitar posición a los bordes teniendo en cuenta el tamaño del tanque
	position.x = clamp(position.x, mitad_ancho, tamanio_pantalla.x - mitad_ancho)
	position.y = clamp(position.y, mitad_alto, tamanio_pantalla.y - mitad_alto)


func _disparar():
	if not escena_proyectil:
		print("No hay escena de proyectil asignada en Tank (arrastrala a 'escena_proyectil' en el inspector o hace preload).")
		return


	# instancia el proyectil
	var proj = escena_proyectil.instance()
	# distancia desde el centro del tanque hasta la punta (ajustá si hace falta)
	var spawn_distance = mitad_ancho + 6
	# posición en la punta según la rotación actual
	proj.position = position + Vector2(cos(rotation), sin(rotation)) * spawn_distance
	# pasar rotación y dirección (opcional)
	proj.rotation = rotation
	# el script del proyectil usa 'direccion' como variable pública
	# asignar dirección si existe la propiedad
	if "direccion" in proj:
		proj.direccion = Vector2(cos(rotation), sin(rotation))
	
	# agregar al mismo padre (Main), podés usar get_tree().root si preferís otro node
	get_parent().add_child(proj)

	# resetear cooldown
	#_fire_cooldown = fire_rate
