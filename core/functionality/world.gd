class_name World extends Node3D

@export var dropped_items: Node
@export var floating_item: PackedScene

func _ready() -> void:
	EventBus.raise(WorldLoadedEvent.new(self))
	EventBus.subscribe(DropItemEvent, drop_item)

func drop_item(event: DropItemEvent) -> void:
	var drop: Node3D = SceneLoader.get_scene_instance(event.item.dropped_model) as Node3D
	var floater: Entity = floating_item.instantiate()
	dropped_items.add_child(floater)
	floater.global_position = event.position
	var comp: DroppedItemInteractionComponent = floater.get_component(DroppedItemInteractionComponent)
	comp.set_data(event.item, event.quantity)
	floater.add_child(drop)
