@tool
extends EditorPlugin

var my_custom_dock: Control

func _enter_tree() -> void:
	my_custom_dock = Control.new()
	my_custom_dock.name = "Dev Tools"
	
	var button_container = VBoxContainer.new()
	button_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	my_custom_dock.add_child(button_container)
	
	var generate_button = Button.new()
	generate_button.text = "Generate World"
	generate_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	generate_button.pressed.connect(_on_generate_button_pressed)
	button_container.add_child(generate_button)
	
	var open_button = Button.new()
	open_button.text = "Open Testworld"
	open_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	open_button.pressed.connect(_on_open_button_pressed)
	button_container.add_child(open_button)
	
	var generate_random = Button.new()
	generate_random.text = "Generate Random World"
	generate_random.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	generate_random.pressed.connect(_on_generate_random_pressed)
	button_container.add_child(generate_random)

	add_control_to_dock(DOCK_SLOT_LEFT_BR, my_custom_dock)

func _on_generate_random_pressed() -> void:
	var ei = get_editor_interface()
	var scene_path = "res://Scenes/test_world.tscn"
	var current_scene = ei.get_edited_scene_root()
	
	if not current_scene or current_scene.scene_file_path != scene_path:
		print("Opening test scene...")
		ei.open_scene_from_path(scene_path)
		await get_tree().process_frame
		current_scene = ei.get_edited_scene_root()

	if current_scene:
		var generator = current_scene
		if generator and generator.has_method("generate_random_world"):
			generator.generate_random_world()
			print("Generation complete!")
		else:
			printerr("Error: Could not find 'TestWorld' node with the required method.")

func _on_open_button_pressed() -> void:
	var ei = get_editor_interface()
	var scene_path = "res://Scenes/test_world.tscn"
	
	var current_scene = ei.get_edited_scene_root()
	
	if not current_scene or current_scene.scene_file_path != scene_path:
		print("Opening test scene...")
		ei.open_scene_from_path(scene_path)
		await get_tree().process_frame
		current_scene = ei.get_edited_scene_root()
	if current_scene:
		var generator = current_scene
		if generator and generator.has_method("clear_world"):
			#generator.clear_world()
			pass

func _on_generate_button_pressed() -> void:
	var ei = get_editor_interface()
	var scene_path = "res://Scenes/test_world.tscn"
	var current_scene = ei.get_edited_scene_root()
	
	if not current_scene or current_scene.scene_file_path != scene_path:
		print("Opening test scene...")
		ei.open_scene_from_path(scene_path)
		await get_tree().process_frame
		current_scene = ei.get_edited_scene_root()

	if current_scene:
		var generator = current_scene
		if generator and generator.has_method("generate_world"):
			generator.generate_world()
			print("Generation complete!")
		else:
			printerr("Error: Could not find 'TestWorld' node with the required method.")

func _exit_tree() -> void:
	if my_custom_dock:
		remove_control_from_docks(my_custom_dock)
		my_custom_dock.free()
