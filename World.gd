extends Node3D

const PLAYER_SCENE = preload("res://scenes/Player.tscn")
const HUD_SCRIPT = preload("res://scripts/HUD.gd")
const DUMMY_SCRIPT = preload("res://scripts/TargetDummy.gd")
const OBJECTIVE_SCRIPT = preload("res://scripts/ObjectiveArea.gd")

func _ready() -> void:
    GameState.reset_mission()
    _build_environment()
    var player = PLAYER_SCENE.instantiate()
    player.position = Vector3(0, 0, 8)
    add_child(player)
    player.add_to_group("player")
    player.ammo_changed.connect(_on_ammo_changed)

    var hud = CanvasLayer.new()
    hud.set_script(HUD_SCRIPT)
    add_child(hud)

    _create_dummy(Vector3(-5, 0, -8))
    _create_dummy(Vector3(5, 0, -12))
    _create_dummy(Vector3(0, 0, -18))
    _create_objective(Vector3(0, 1, -22), false)
    _create_objective(Vector3(0, 1, -34), true)

func _on_ammo_changed(current: int, reserve: int) -> void:
    get_tree().call_group("hud", "set_ammo", current, reserve)

func _mat(color: Color, roughness: float = 0.9) -> StandardMaterial3D:
    var m := StandardMaterial3D.new()
    m.albedo_color = color
    m.roughness = roughness
    return m

func _add_box(parent: Node3D, pos: Vector3, size: Vector3, color: Color) -> StaticBody3D:
    var body := StaticBody3D.new()
    body.position = pos
    var mesh := MeshInstance3D.new()
    var shape_mesh := BoxMesh.new()
    shape_mesh.size = size
    mesh.mesh = shape_mesh
    mesh.material_override = _mat(color)
    body.add_child(mesh)
    var col := CollisionShape3D.new()
    var shape := BoxShape3D.new()
    shape.size = size
    col.shape = shape
    body.add_child(col)
    parent.add_child(body)
    return body

func _build_environment() -> void:
    var world_env := WorldEnvironment.new()
    var env := Environment.new()
    env.background_mode = Environment.BG_SKY
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color(0.34, 0.39, 0.43)
    env.ambient_light_energy = 0.65
    env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
    env.fog_enabled = true
    env.fog_light_color = Color(0.38, 0.43, 0.45)
    env.fog_density = 0.008
    world_env.environment = env
    add_child(world_env)

    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-48, -25, 0)
    sun.light_energy = 1.15
    sun.shadow_enabled = true
    add_child(sun)

    _add_box(self, Vector3(0, -0.55, -12), Vector3(70, 1, 90), Color(0.19, 0.22, 0.20))
    # Low-poly rocky perimeter and simple cover blocks.
    for i in range(14):
        var x := -28.0 + float(i) * 4.2
        _add_box(self, Vector3(x, 1.2, -43), Vector3(3.6, 2.4, 2.0), Color(0.24, 0.27, 0.26))
    for i in range(9):
        var z := -34.0 + float(i) * 5.0
        _add_box(self, Vector3(-30, 1.0, z), Vector3(2.0, 2.0, 4.0), Color(0.25, 0.28, 0.27))
        _add_box(self, Vector3(30, 1.0, z), Vector3(2.0, 2.0, 4.0), Color(0.25, 0.28, 0.27))
    _add_box(self, Vector3(-9, 1.1, -12), Vector3(5, 2.2, 2.2), Color(0.27, 0.29, 0.28))
    _add_box(self, Vector3(10, 1.1, -20), Vector3(6, 2.2, 2.0), Color(0.27, 0.29, 0.28))
    _add_box(self, Vector3(0, 2.0, -29), Vector3(13, 4, 1.2), Color(0.20, 0.23, 0.23))
    # Crates provide readable cover and scale.
    for p in [Vector3(-4,0,-5), Vector3(4,0,-6), Vector3(8,0,-15), Vector3(-11,0,-24)]:
        _add_box(self, p + Vector3(0,0.65,0), Vector3(1.4,1.3,1.4), Color(0.32,0.29,0.22))

func _create_dummy(pos: Vector3) -> void:
    var enemy := StaticBody3D.new()
    enemy.set_script(DUMMY_SCRIPT)
    enemy.position = pos
    var mesh := MeshInstance3D.new()
    var capsule := CapsuleMesh.new()
    capsule.radius = 0.42
    capsule.height = 1.8
    mesh.mesh = capsule
    mesh.position.y = 0.9
    mesh.material_override = _mat(Color(0.22, 0.27, 0.24))
    enemy.add_child(mesh)
    var col := CollisionShape3D.new()
    var shape := CapsuleShape3D.new()
    shape.radius = 0.42
    shape.height = 1.8
    col.shape = shape
    col.position.y = 0.9
    enemy.add_child(col)
    add_child(enemy)

func _create_objective(pos: Vector3, extraction: bool) -> void:
    var area := Area3D.new()
    area.set_script(OBJECTIVE_SCRIPT)
    area.is_extraction = extraction
    area.position = pos
    var mesh := MeshInstance3D.new()
    var sphere := SphereMesh.new()
    sphere.radius = 0.65
    sphere.height = 1.3
    mesh.mesh = sphere
    var material := _mat(Color(0.12, 0.85, 0.72) if not extraction else Color(0.95, 0.65, 0.12), 0.35)
    material.emission_enabled = true
    material.emission = material.albedo_color
    mesh.material_override = material
    area.add_child(mesh)
    var col := CollisionShape3D.new()
    var shape := SphereShape3D.new()
    shape.radius = 1.6
    col.shape = shape
    area.add_child(col)
    add_child(area)
