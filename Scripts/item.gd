@abstract class_name Item extends Node3D

@abstract func use(animator: AnimationPlayer, player: Player) -> void
@abstract func on_equip() -> void
@abstract func on_animation_trigger(event: String) -> void

@abstract func on_animation_start() -> void
@abstract func on_animation_end() -> void


@abstract func _get_animation() -> String
