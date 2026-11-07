extends Area3D

@export var is_extraction := false
var activated := false

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
    if activated or not body.is_in_group("player"):
        return
    if is_extraction:
        if GameState.intel_collected:
            activated = true
            GameState.mission_complete = true
            get_tree().call_group("hud", "show_message", "MISSION COMPLETE — INTEL SECURED")
        else:
            get_tree().call_group("hud", "show_message", "INTEL REQUIRED — SEARCH THE SITE")
    else:
        activated = true
        GameState.intel_collected = true
        get_tree().call_group("hud", "show_message", "ENCRYPTED FIELD DRIVE RECOVERED")
