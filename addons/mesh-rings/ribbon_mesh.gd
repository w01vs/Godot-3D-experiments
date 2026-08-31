@tool
class_name RibbonMeshInstance3D extends MeshInstance3D

var global_ring: PackedVector3Array
@export var color: Color = Color.BLACK:
	set(value):
		color = value
		mat.albedo_color = color
		_rebuild()
@export var line_width: float = 0.05:
	set(value):
		line_width = value
		_rebuild()
var mat := StandardMaterial3D.new()

func _init(ring: PackedVector3Array = []) -> void:
	global_ring = ring
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mat.albedo_color = color
	material_override = mat


func _ready() -> void:
	if !Engine.is_editor_hint():
		queue_free()
	else:
		_rebuild()

func _rebuild() -> void:
	if !mesh:
		mesh = ImmediateMesh.new()
	if global_ring.size() < 3:
		return
	var imm_mesh := mesh as ImmediateMesh
	imm_mesh.clear_surfaces()
	imm_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	var inverse: Transform3D = global_transform.affine_inverse()
	var point_count := global_ring.size()
	for i in range(point_count + 1):
		var p := inverse * global_ring[i % point_count] 
		var next_p := inverse * global_ring[(i + 1) % point_count]
		var dir := (next_p - p).normalized()
		var normal: Vector3 = Vector3(-dir.z, 0, dir.x) * (line_width * 0.5)
		imm_mesh.surface_add_vertex(p - normal)
		imm_mesh.surface_add_vertex(p + normal)
	imm_mesh.surface_end()
