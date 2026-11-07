extends CharacterBody3D

@export var walk_speed: float = 4.8
@export var sprint_speed: float = 7.2
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.0022
@export var max_ammo: int = 30
@export var reserve_ammo: int = 120
@export var damage: float = 34.0
@export var fire_rate: float = 0.16

var ammo: int = 30
var can_fire: bool = true
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var third_person := false
var paused_by_escape := false

@onready var pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/SpringArm3D/Camera3D
@onready var body_mesh: MeshInstance3D = $BodyMesh

signal ammo_changed(current: int, reserve: int)
signal player_fired

func _ready() -> void:
    ammo = max_ammo
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    camera.current = true
    _update_camera_mode()
    ammo_changed.emit(ammo, reserve_ammo)

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        rotate_y(-event.relative.x * mouse_sensitivity)
        pivot.rotate_x(-event.relative.y * mouse_sensitivity)
        pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-75), deg_to_rad(65))
    elif event is InputEventKey and event.pressed and not event.echo:
        if event.keycode == KEY_V:
            third_person = not third_person
            _update_camera_mode()
        elif event.keycode == KEY_R:
            reload_weapon()
        elif event.keycode == KEY_ESCAPE:
            if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
                Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
                paused_by_escape = true
            else:
                Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
                paused_by_escape = false
    elif event is InputEventMouseButton and event.pressed:
        if event.button_index == MOUSE_BUTTON_LEFT and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
            fire_weapon()

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= gravity * delta
    elif Input.is_key_pressed(KEY_SPACE):
        velocity.y = jump_velocity

    var input_dir := Vector2(
        float(Input.is_key_pressed(KEY_D)) - float(Input.is_key_pressed(KEY_A)),
        float(Input.is_key_pressed(KEY_S)) - float(Input.is_key_pressed(KEY_W))
    ).normalized()
    var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    var speed := sprint_speed if Input.is_key_pressed(KEY_SHIFT) else walk_speed
    if direction:
        velocity.x = direction.x * speed
        velocity.z = direction.z * speed
    else:
        velocity.x = move_toward(velocity.x, 0.0, walk_speed * 5.0 * delta)
        velocity.z = move_toward(velocity.z, 0.0, walk_speed * 5.0 * delta)
    move_and_slide()

func _update_camera_mode() -> void:
    body_mesh.visible = third_person
    var spring: SpringArm3D = $CameraPivot/SpringArm3D
    spring.spring_length = 3.6 if third_person else 0.0
    camera.position = Vector3(0, 0, 0) if third_person else Vector3(0, 0, 0)
    pivot.position.y = 1.55 if not third_person else 1.65

func fire_weapon() -> void:
    if not can_fire or ammo <= 0:
        if ammo <= 0:
            ammo_changed.emit(ammo, reserve_ammo)
        return
    ammo -= 1
    ammo_changed.emit(ammo, reserve_ammo)
    player_fired.emit()
    var from := camera.global_position
    var to := from + (-camera.global_transform.basis.z * 120.0)
    var query := PhysicsRayQueryParameters3D.create(from, to)
    query.exclude = [get_rid()]
    var result := get_world_3d().direct_space_state.intersect_ray(query)
    if not result.is_empty():
        var hit = result.get("collider")
        if hit and hit.has_method("take_damage"):
            hit.take_damage(damage)
    can_fire = false
    await get_tree().create_timer(fire_rate).timeout
    can_fire = true

func reload_weapon() -> void:
    if ammo >= max_ammo or reserve_ammo <= 0:
        return
    var needed := max_ammo - ammo
    var loaded := min(needed, reserve_ammo)
    ammo += loaded
    reserve_ammo -= loaded
    ammo_changed.emit(ammo, reserve_ammo)
