class_name Laser extends CRayCast3D

@export var anim: AnimationPlayer
var cooldown: bool
@export var beam_out: GPUParticles3D
@export var beam_in: GPUParticles3D
@export var beam_cap: GPUParticles3D
@export var fade: MeshInstance3D

var default_length: float = 15
var max_length: float = 15

func _enter_tree() -> void:
	var mat: ShaderMaterial = fade.material_override
	mat.set_shader_parameter("draw_progress", 0.0)

func _ready() -> void:
	anim.animation_finished.connect(end)
	beam_out.emitting = false
	beam_in.emitting = false
	beam_cap.emitting = false

func _physics_process(_delta: float) -> void:
	if cooldown:
		var mat: ParticleProcessMaterial = beam_in.process_material as ParticleProcessMaterial
		var mat2: ParticleProcessMaterial = beam_out.process_material as ParticleProcessMaterial
		if is_colliding():
			var target: Vector3 = get_collision_point()
			var length: float = abs((global_position - target).length())
			var percent_len: float = length / default_length
			beam_cap.global_position = target
			mat.scale_3d_max.z = percent_len
			mat.scale_3d_min.z= percent_len
			mat2.scale_3d_max.z = percent_len
			mat2.scale_3d_min.z= percent_len
		else:
			beam_cap.position = Vector3(0, 0, -default_length)
			mat.scale_3d_max.z = 1
			mat.scale_3d_min.z = 1
			mat2.scale_3d_max.z = 1
			mat2.scale_3d_min.z = 1

func end(_name: StringName) -> void:
	cooldown = false

func fire() -> void:
	if !cooldown:
		anim.play("laser")
		cooldown = true
	
