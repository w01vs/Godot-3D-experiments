extends ConditionalNodeBT

@export var actor: SimpleEnemy

var player: Player
var space_state: PhysicsDirectSpaceState3D

var origin
var end

@onready var draw: Draw3D = $Draw3D

func _ready() -> void:
	player = GlobalRefs.player
	space_state = actor.get_world_3d().direct_space_state

func condition() -> bool:
	return sight()

func sight() -> bool:
	var res: bool = false
	var sight_box: Area3D = actor.get_node("SightBox")
	if sight_box != null:
		var colliders = sight_box.get_overlapping_bodies()
		for i in colliders:
			if i is Player:
				origin = actor.eye.global_position
				end = player.global_position #(-actor.transform.basis.z).normalized() * actor.max_view_distance
				var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end)
				query.exclude = [actor.get_rid()]
				var result = space_state.intersect_ray(query)
				draw.clear()
				draw.draw_line([origin, end], Color.RED)
				if result.collider is Player:
					res = true
	if actor.sight_changed and not res:
		actor.sight_changed = true
	else:
		actor.sight_changed = false
	return res
		# probe width of player
		# maybe probe height as well?
