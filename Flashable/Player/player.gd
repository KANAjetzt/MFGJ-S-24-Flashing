extends Flashable
class_name Player

signal throw_before(flash: Flash, origin: Vector3, force: Vector3)
signal throw(flash: Flash, origin: Vector3, force: Vector3)

@export var flash_scene: PackedScene
@export var flash_dummy_scene: PackedScene

@export_range(1.0, 20.0, 1.0) var throw_force_multiplier: float
@export_range(1.0, 10.0, 1.0) var light_throw_force_multiplier: float

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.25

@onready var head: Node3D = %Head
@onready var flash_container: Node3D = %FlashContainer
@onready var hand: Node3D = %Hand
@onready var flash_dummy: Flash = %FlashDummy
@onready var camera: PhantomCamera3D = %Camera
@onready var gpu_particles_3d: GPUParticles3D = %GPUParticles3D
@onready var gpu_particles_3d_2: GPUParticles3D = %GPUParticles3D2



var can_throw := true :
	set(new_value):
		can_throw = new_value
		if new_value == true:
			flash_dummy.show()
		else:
			flash_dummy.hide()
var current_flash: Flash
# flash_count -1 == no flash limit
var flash_count := -1 :
	set(new_value):
		flash_count = new_value
		if flash_count == 0:
			can_throw = false
		if flash_count > 0 or flash_count == -1:
			can_throw = true
		if flash_count == -1:
			Global.hud.panel_flash_count.label_text = "unlimited"
		else:
			Global.hud.panel_flash_count.label_text = "%sx" % new_value
		
# Used to disable throwing and moving in camera transitions
var is_input_disabled := false


func _ready() -> void:
	Global.player = self


func _input(event: InputEvent) -> void:
	if is_input_disabled:
		return
	
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))
		head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSITIVITY))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	
	if event.is_action_pressed("throw"):
		init_throw_before()
	
	if event.is_action_released("throw"):
		init_throw()
	
	if event.is_action_pressed("throw_light"):
		init_throw_before()
		
	if event.is_action_released("throw_light"):
		init_light_throw()


func _physics_process(delta: float) -> void:
	handle_movement(delta)


func handle_movement(delta: float) -> void:
	if is_input_disabled:
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
			
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
	if flash_count == 0:
		return
	await get_tree().create_timer(0.25).timeout
	can_throw = true


func init_throw_before() -> void:
	if not can_throw or flash_count == 0:
		return
	
	if not flash_count == -1:
		flash_count = flash_count - 1
	can_throw = false
	current_flash = flash_scene.instantiate()
	flash_container.add_child(current_flash)
	throw_before.emit(current_flash, Global.camera.global_position, -Global.camera.get_global_transform().basis.z * throw_force_multiplier)
	

func init_throw() -> void:
	if not current_flash:
		return
		
	flash_container.remove_child(current_flash)
	throw.emit(current_flash, Global.camera.global_position, -Global.camera.get_global_transform().basis.z * throw_force_multiplier)
	current_flash = null


func init_light_throw() -> void:
	if not current_flash:
		return
		
	flash_container.remove_child(current_flash)
	throw.emit(current_flash, Global.camera.global_position, (-Global.camera.get_global_transform().basis.z + Vector3(0.0, 0.9, 0.0)) * light_throw_force_multiplier)
	current_flash = null


func teleport(transfrom: Transform3D) -> void:
	global_transform = transfrom


func activate_camera() -> void:
	deactivate_particles()
	Global.active_camera = camera


func activate_particles() -> void:
	gpu_particles_3d.emitting = true
	gpu_particles_3d_2.emitting = true


func deactivate_particles() -> void:
	gpu_particles_3d.emitting = false
	gpu_particles_3d_2.emitting = false


func _on_camera_tween_completed() -> void:
	is_input_disabled = false
