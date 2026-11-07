extends CanvasLayer

var status_label: Label
var ammo_label: Label
var objective_label: Label
var crosshair: Label

func _ready() -> void:
    add_to_group("hud")
    var root := Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(root)

    status_label = Label.new()
    status_label.position = Vector2(24, 22)
    status_label.add_theme_font_size_override("font_size", 20)
    status_label.text = "BLACK HORIZON  |  OPERATION 01"
    root.add_child(status_label)

    objective_label = Label.new()
    objective_label.position = Vector2(24, 56)
    objective_label.add_theme_font_size_override("font_size", 16)
    objective_label.text = "OBJECTIVE: Recover the encrypted field drive"
    root.add_child(objective_label)

    ammo_label = Label.new()
    ammo_label.anchor_left = 1.0
    ammo_label.anchor_right = 1.0
    ammo_label.offset_left = -220
    ammo_label.offset_top = -64
    ammo_label.offset_right = -24
    ammo_label.offset_bottom = -24
    ammo_label.add_theme_font_size_override("font_size", 22)
    ammo_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
    ammo_label.text = "30 / 120"
    root.add_child(ammo_label)

    crosshair = Label.new()
    crosshair.anchor_left = 0.5
    crosshair.anchor_top = 0.5
    crosshair.anchor_right = 0.5
    crosshair.anchor_bottom = 0.5
    crosshair.offset_left = -10
    crosshair.offset_top = -16
    crosshair.offset_right = 10
    crosshair.offset_bottom = 16
    crosshair.text = "+"
    crosshair.add_theme_font_size_override("font_size", 26)
    crosshair.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    root.add_child(crosshair)

    var hint := Label.new()
    hint.anchor_top = 1.0
    hint.anchor_bottom = 1.0
    hint.offset_left = 24
    hint.offset_top = -42
    hint.offset_right = 800
    hint.offset_bottom = -16
    hint.text = "WASD MOVE  |  SHIFT SPRINT  |  SPACE JUMP  |  V CAMERA  |  LMB FIRE  |  R RELOAD  |  ESC MOUSE"
    hint.add_theme_font_size_override("font_size", 13)
    root.add_child(hint)

func set_ammo(current: int, reserve: int) -> void:
    if is_instance_valid(ammo_label):
        ammo_label.text = "%02d / %03d" % [current, reserve]

func show_message(message: String) -> void:
    if is_instance_valid(status_label):
        status_label.text = message
    if GameState.mission_complete:
        objective_label.text = "OBJECTIVE COMPLETE — RETURN TO MENU WITH ESC"
    elif GameState.intel_collected:
        objective_label.text = "OBJECTIVE: Reach the marked extraction zone"
