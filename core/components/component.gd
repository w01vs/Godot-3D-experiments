@abstract class_name Component extends Node

## The entity the component is attached to
@export var entity: Entity
## Represents wether a component is functional or not.
var active: bool = true

## All C-versions are very similar: They store what type of component uses them and emit an event through their entity when they are loaded.
## [br]Current C-versions are:
## [br][b]CollisionObject3D[/b]: [CArea3D] - [CStaticBody3D] - [CCharacterBody3D]
## [br][b]RayCast3D[/b]: [CRayCast3D]
const C_version: Script = null

## The [code]_ready()[/code] function should [b]never be overriden[/b] in a component.
func _ready() -> void:
	assert(entity != null, "Component %s at %s requires an entity it is attached to." % [ name, get_path() ])
	assert(entity.is_ancestor_of(self), "Component %s at %s requires its entity to be an ancestor."% [ name, get_path() ] )
	entity.register(self)
	entity.subscribe(self, EntityLoadedEvent, _on_entity_load)
	entity.raise_local(ComponentRegisteredEntityEvent.new(self))
	_init_component()

## Called when the parent entity finished loading.
func _on_entity_load(_event: EntityLoadedEvent) -> void:
	pass

## Called when the component is loading.
func _init_component() -> void:
	pass

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if !Engine.is_editor_hint():
			if entity:
				entity.remove_component(self)
				pass

func is_active() -> bool:
	return active

## Enables the component's functionality.
func enable() -> void:
	active = true
	_on_enable()
	
## Called when the component is enabled.
func _on_enable() -> void:
	pass

## Disables the component's functionality. Subscribing or initialisation will continue regardless.
func disable() -> void:
	active = false
	_on_disable()

## Called when the component is disabled.
func _on_disable() -> void:
	pass

func subscribe(event: Script, callback: Callable, prio: EventBase.Priority = EventBase.Priority.BASE) -> void:
	entity.subscribe(self, event, callback, prio)
