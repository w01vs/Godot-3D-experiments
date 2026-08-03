class_name Laser extends Node3D

@export var anim: AnimationPlayer
var cooldown: bool
@export var beam_out: GPUParticles3D
@export var beam_in: GPUParticles3D
@export var beam_cap: GPUParticles3D
@export var fade: MeshInstance3D

func _enter_tree() -> void:
	var mat: ShaderMaterial = fade.material_override
	mat.set_shader_parameter("draw_progress", 0.0)

func _ready() -> void:
	anim.animation_finished.connect(end)
	beam_out.emitting = false
	beam_in.emitting = false
	beam_cap.emitting = false

func end(_name: StringName) -> void:
	cooldown = false

func fire() -> void:
	if !cooldown:
		anim.play("laser")
		cooldown = true
	
