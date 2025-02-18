extends ImageEffect

var red := true
var green := true
var blue := true
var alpha := false

var shader: Shader = preload("res://src/Shaders/Desaturate.shader")

var confirmed: bool = false


func _about_to_show() -> void:
	var sm := ShaderMaterial.new()
	sm.shader = shader
	preview.set_material(sm)
	._about_to_show()


func set_nodes() -> void:
	preview = $VBoxContainer/AspectRatioContainer/Preview
	selection_checkbox = $VBoxContainer/OptionsContainer/SelectionCheckBox
	affect_option_button = $VBoxContainer/OptionsContainer/AffectOptionButton


func _confirmed() -> void:
	confirmed = true
	._confirmed()


func commit_action(cel: Image, project: Project = Global.current_project) -> void:
	var selection: Image = project.bitmap_to_image(project.selection_bitmap, false)
	var selection_tex := ImageTexture.new()
	selection_tex.create_from_image(selection)

	if !confirmed:
		preview.material.set_shader_param("red", red)
		preview.material.set_shader_param("blue", blue)
		preview.material.set_shader_param("green", green)
		preview.material.set_shader_param("alpha", alpha)
		preview.material.set_shader_param("selection", selection_tex)
		preview.material.set_shader_param("affect_selection", selection_checkbox.pressed)
		preview.material.set_shader_param("has_selection", project.has_selection)
	else:
		var params := {
			"red": red,
			"blue": blue,
			"green": green,
			"alpha": alpha,
			"selection": selection_tex,
			"affect_selection": selection_checkbox.pressed,
			"has_selection": project.has_selection
		}
		var gen := ShaderImageEffect.new()
		gen.generate_image(cel, shader, params, project.size)
		yield(gen, "done")


func _on_RButton_toggled(button_pressed: bool) -> void:
	red = button_pressed
	update_preview()


func _on_GButton_toggled(button_pressed: bool) -> void:
	green = button_pressed
	update_preview()


func _on_BButton_toggled(button_pressed: bool) -> void:
	blue = button_pressed
	update_preview()


func _on_AButton_toggled(button_pressed: bool) -> void:
	alpha = button_pressed
	update_preview()
