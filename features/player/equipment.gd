class_name EquipmentComponent extends Component

var held_item: ItemModelComponent
var item_cache: Array[Entity]

@export var marker: Marker3D
@export var remote_transform: RemoteTransform3D
@export var animation_tree: AnimationTree

var using_held_item: bool

func _init_component() -> void:
	entity.subscribe_global(self, PlayerInventoryLoadedEvent, initialise)
	entity.subscribe_global(self, HotbarActiveChangedEvent, swap_item)
	entity.subscribe_global(self, WorldLoadedEvent, _link_input)
	entity.subscribe(self, AnimationTypeChangeEntityEvent, _set_animation_type)

func _set_animation_type(event: AnimationTypeChangeEntityEvent) -> void:
	animation_tree.set("parameters/Transition/transition_request", event.type)

func _link_input(_event: WorldLoadedEvent) -> void:
	InputManager.subscribe(PrimaryAttackInputEvent, _use_held_item)

func _use_held_item(_event: PrimaryAttackInputEvent) -> void:
	# Set animation state machine transition flag 
	using_held_item = true

func initialise(event: PlayerInventoryLoadedEvent) -> void:
		item_cache.resize(event.hotbar_data.size)
		for i in range(event.hotbar_items.size()):
			var item: ItemData = event.hotbar_items[i]
			load_item(i, item)
		event.bindings.equipment_changed.connect(_change_item)

func _change_item(index: int, data: ItemData, update: bool) -> void:
	if data:
		load_item(index, data)
	else:
		unload_item(index)
	
	if update:
		on_active_item_swap.call_deferred(index)

func load_item(index: int, data: ItemData) -> void:
	if item_cache[index]:
		unload_item(index)
	if data.model.is_empty():
		return
	item_cache[index] = SceneLoader.get_scene_instance(data.model) as Entity
	item_cache[index].disable()
	marker.add_child(item_cache[index])
	if !item_cache[index].has_component(ItemModelComponent):
		assert(false)
		push_error("Trying to equip something that has no item model.")
		return

func unload_item(index: int) -> void:
	if item_cache[index]:
		var item: ItemModelComponent = item_cache[index].get_component(ItemModelComponent)
		item.delete()
		item_cache[index] = null

func on_active_item_swap(index: int) -> void:
	if held_item:
		held_item.unequip()
	if !item_cache[index]:
		# Set current animation to default (should be an idle/walk/run state)
		entity.raise_local(AnimationTypeChangeEntityEvent.new(self, str(AnimationType.CUSTOM)))
		return
	if !item_cache[index].has_component(ItemModelComponent):
		assert(false)
		push_error("Trying to equip something that has no item model.")
		return
	held_item = item_cache[index].get_component(ItemModelComponent)
	held_item.equip()
	remote_transform.remote_path = remote_transform.get_path_to(item_cache[index])
	#remote_transform.force_update_cache()
	#remote_transform.force_update_transform()
	if held_item.data.has_animation:
		entity.raise_local(AnimationTypeChangeEntityEvent.new(self, str(held_item.data.animation_type)))
	else:
		entity.raise_local(AnimationTypeChangeEntityEvent.new(self, str(AnimationType.CUSTOM)))

func swap_item(event: HotbarActiveChangedEvent) -> void:
	on_active_item_swap.call_deferred(event.index)

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
