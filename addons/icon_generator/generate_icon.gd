# res://addons/icon_generator/plugin.gd
@tool
extends EditorPlugin

var btn: Button

func _enter_tree() -> void:
	btn = Button.new()
	btn.text = "Make Icon"
	btn.flat = true
	btn.pressed.connect(_on_render_pressed)
	add_control_to_container(CONTAINER_SPATIAL_EDITOR_MENU, btn)

func _exit_tree() -> void:
	if btn:
		remove_control_from_container(CONTAINER_CANVAS_EDITOR_MENU, btn)
		btn.queue_free()

func _on_render_pressed() -> void:
	var current_scene = get_editor_interface().get_edited_scene_root()
	if not current_scene:
		return

	var camera: Camera3D = _find_camera(current_scene)
	if not camera:
		printerr("No Camera3D found in current scene!")
		return

	# 1. Create offscreen SubViewport directly inside editor
	var sub_viewport = SubViewport.new()
	sub_viewport.size = Vector2i(1024, 1024)
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	sub_viewport.transparent_bg = true
	
	# Add temporarily to editor tree
	get_editor_interface().get_base_control().add_child(sub_viewport)

	# 2. Duplicate camera into SubViewport
	var cam_dup = camera.duplicate() as Camera3D
	sub_viewport.add_child(cam_dup)
	cam_dup.global_transform = camera.global_transform

	# 3. Wait 1 frame for Editor Renderer to draw
	await RenderingServer.frame_post_draw

	# 4. Capture & Save
	var img = sub_viewport.get_texture().get_image()
	img.resize(96, 96, Image.INTERPOLATE_LANCZOS)
	
	var save_path = _get_next_filename("res://addons/icon_generator/icons/icon", ".png")
	img.save_png(save_path)
	print("SUCCESS: Rendered icon directly in editor to: ", save_path)

	# Cleanup
	sub_viewport.queue_free()

func _find_camera(node: Node) -> Camera3D:
	if node is Camera3D:
		return node
	for child in node.get_children():
		var found = _find_camera(child)
		if found:
			return found
	return null

func _get_next_filename(base_path: String, extension: String) -> String:
	var counter = 1
	var path = "%s%d%s" % [base_path, counter, extension]
	while FileAccess.file_exists(path):
		counter += 1
		path = "%s%d%s" % [base_path, counter, extension]
	return path
