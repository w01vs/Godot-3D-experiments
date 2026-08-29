class_name EquipmentComponent extends Component

var held_item: ItemModelComponent
var item_cache: Array[Entity]

@export var marker: Marker3D
@export var remote_transform: RemoteTransform3D
@export var animation_tree: AnimationTree

var using_held_item: bool

func _init_component() -> void:
	entity.subscribe_global(self, PlayerInventoryLoadedEvent, initialise)
	entity.subscribe_global(self, HotbarChangedEvent, swap_item)
	entity.subscribe_global(self, WorldLoadedEvent, _link_input)
	entity.subscribe(self, AnimationTypeChangeEntityEvent, _set_animation_type)

func _set_animation_type(event: AnimationTypeChangeEntityEvent) -> void:
	animation_tree.set("parameters/Transition/transition_request", event.type)

func _link_input(_event: WorldLoadedEvent) -> void:
	InputManager.subscribe(PrimaryAttackInputEvent, _use_held_item)

func _use_held_item(_event: PrimaryAttackInputEvent) -> void:
	using_held_item = true

func initialise(event: PlayerInventoryLoadedEvent) -> void:
		item_cache.resize(event.hotbar_data.size)
		for i in range(event.hotbar_items.size()):
			var item: ItemData = event.hotbar_items[i]
			load_item(i, item)
		event.bindings.equipment_changed.connect(_change_item)

func _change_item(index: int, data: ItemData) -> void:
	if data:
		load_item(index, data)
	else:
		unload_item(index)

func load_item(index: int, data: ItemData) -> void:
	item_cache[index] = data.model.instantiate() as Entity
	item_cache[index].disable()
	marker.add_child(item_cache[index])
	if !item_cache[index].has_component(ItemModelComponent):
		assert(false)
		push_error("Trying to equip something that has no item model.")
		return
	held_item = item_cache[index].get_component(ItemModelComponent)
	held_item.load(entity, data)

func unload_item(index: int) -> void:
	if item_cache[index]:
		var item: ItemModelComponent = item_cache[index].get_component(ItemModelComponent)
		item.delete()
		item_cache[index] = null

func swap_item(event: HotbarChangedEvent) -> void:
	if held_item:
		held_item.unequip()
		held_item.disable()
	if !item_cache[event.index]:
		entity.raise_local(AnimationTypeChangeEntityEvent.new(self, str(AnimationType.CUSTOM)))
		return
	if !item_cache[event.index].has_component(ItemModelComponent):
		assert(false)
		push_error("Trying to equip something that has no item model.")
		return
	held_item = item_cache[event.index].get_component(ItemModelComponent)
	held_item.equip()
	held_item.enable()
	remote_transform.remote_path = remote_transform.get_path_to(item_cache[event.index])
	remote_transform.force_update_cache()
	remote_transform.force_update_transform()
	entity.raise_local(AnimationTypeChangeEntityEvent.new(self, str(held_item.data.animation_type)))

func _on_animation_trigger(event: StringName) -> void:
	if held_item:
		held_item.on_animation_trigger(event)

func _on_animation_start(animation: StringName) -> void:
	if held_item:
		held_item.on_animation_start(animation)

func _on_animation_end(animation: StringName) -> void:
	if held_item:
		held_item.on_animation_end(animation)
	using_held_item = false
