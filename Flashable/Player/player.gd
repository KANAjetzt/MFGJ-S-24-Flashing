extends Flashable
class_name Player

signal throw(flash: Flash, origin: Vector3, force: Vector3)

@export var flash_scene: PackedScene
@export var flash_dummy_scene: PackedScene

@export_range(1.0, 20.0, 1.0) var throw_force_multiplier: float
@export_range(1.0, 10.0, 1.0) var light_throw_force_multiplier: float

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.25

@onready var head: Node3D = %Head
@onready var hand: Node3D = %Hand
@onready var flash_dummy: Flash = %FlashDummy
@onready var crosshair: TextureRect = %Crosshair
@onready var camera: PhantomCamera3D = %Camera


func _ready() -> void:
	Global.player = self
	crosshair.modulate = Global.settings.crosshair_color


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))
		head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSITIVITY))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

	if event.is_action_pressed("throw"):
		init_throw()
	
	if event.is_action_pressed("throw_light"):
		init_light_throw()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func take() -> void:
	flash_dummy.show()


func init_throw() -> void:
	flash_dummy.hide()
	throw.emit(flash_scene.instantiate(), Global.camera.global_position, -Global.camera.get_global_transform().basis.z * throw_force_multiplier)


func init_light_throw() -> void:
	flash_dummy.hide()
	throw.emit(flash_scene.instantiate(), Global.camera.global_position, (-Global.camera.get_global_transform().basis.z + Vector3(0.0, 0.9, 0.0)) * light_throw_force_multiplier)


func teleport(transfrom: Transform3D) -> void:
	global_transform = transfrom


func activate_camera() -> void:
	Global.active_camera = camera
