extends Control

func _ready() -> void:
    _build_ui()

func _build_ui() -> void:
    var bg := ColorRect.new()
    bg.color = Color(0.035, 0.05, 0.055, 1)
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(bg)

    var title := Label.new()
    title.text = "BLACK HORIZON"
    title.position = Vector2(76, 82)
    title.add_theme_font_size_override("font_size", 54)
    title.add_theme_color_override("font_color", Color(0.88, 0.91, 0.88))
    add_child(title)

    var tagline := Label.new()
    tagline.text = "INFILTRATE.  EXPOSE.  SURVIVE."
    tagline.position = Vector2(82, 151)
    tagline.add_theme_font_size_override("font_size", 17)
    tagline.add_theme_color_override("font_color", Color(0.35, 0.78, 0.70))
    add_child(tagline)

    var sub := Label.new()
    sub.text = "TACTICAL OPERATIONS  //  CAMPAIGN PROTOTYPE"
    sub.position = Vector2(82, 205)
    sub.add_theme_font_size_override("font_size", 14)
    sub.add_theme_color_override("font_color", Color(0.62, 0.67, 0.66))
    add_child(sub)

    var mission_title := Label.new()
    mission_title.text = "SELECT OPERATION"
    mission_title.position = Vector2(84, 285)
    mission_title.add_theme_font_size_override("font_size", 18)
    add_child(mission_title)

    var list := OptionButton.new()
    list.position = Vector2(82, 325)
    list.size = Vector2(430, 48)
    list.add_theme_font_size_override("font_size", 16)
    for mission in GameState.MISSIONS:
        list.add_item(mission["title"])
    list.select(GameState.selected_mission)
    add_child(list)

    var description := Label.new()
    description.position = Vector2(82, 390)
    description.size = Vector2(520, 90)
    description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    description.add_theme_font_size_override("font_size", 15)
    description.add_theme_color_override("font_color", Color(0.68, 0.72, 0.70))
    description.text = GameState.MISSIONS[0]["location"] + "\n" + GameState.MISSIONS[0]["objective"]
    add_child(description)
    list.item_selected.connect(func(index: int):
        GameState.selected_mission = index
        description.text = GameState.MISSIONS[index]["location"] + "\n" + GameState.MISSIONS[index]["objective"]
    )

    var start := Button.new()
    start.text = "DEPLOY  →"
    start.position = Vector2(82, 510)
    start.size = Vector2(220, 56)
    start.add_theme_font_size_override("font_size", 19)
    add_child(start)
    start.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/World.tscn"))

    var note := Label.new()
    note.text = "BUILD 01  |  GODOT 4 COMPATIBILITY RENDERER  |  PROTOTYPE"
    note.position = Vector2(82, 630)
    note.add_theme_font_size_override("font_size", 12)
    note.add_theme_color_override("font_color", Color(0.42, 0.48, 0.47))
    add_child(note)
