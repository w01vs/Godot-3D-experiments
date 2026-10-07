#include "component_staticbody3d.hpp"
#include "events/collision_entered_event.hpp"
#include "events/collision_exit_event.hpp"
#include "events/collision_oneshot_event.hpp"
#include "../component.hpp"

void ComponentStaticBody3D::_bind_methods() {
	ClassDB::bind_method(D_METHOD("enter", " data"), &ComponentStaticBody3D::enter);
	ClassDB::bind_method(D_METHOD("oneshot", " data"), &ComponentStaticBody3D::oneshot);
	ClassDB::bind_method(D_METHOD("exit", " data"), &ComponentStaticBody3D::exit);

	ClassDB::bind_method(D_METHOD("cset_collision_layer_value", "value", "on"), &ComponentStaticBody3D::cset_collision_layer_value);
	ClassDB::bind_method(D_METHOD("cset_collision_mask_value", "value", "on"), &ComponentStaticBody3D::cset_collision_mask_value);
	ClassDB::bind_method(D_METHOD("get_entity"),&ComponentStaticBody3D::get_entity);
	ClassDB::bind_method(D_METHOD("set_entity"),&ComponentStaticBody3D::set_entity);
	ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "entity", PROPERTY_HINT_NODE_TYPE, "Entity"), "set_entity", "get_entity");
}

void ComponentStaticBody3D::_ready() {
    assert(entity);
    set_collision_layer(0);
    set_collision_mask(0);
    add_to_group(Component::GROUP);
}

void ComponentStaticBody3D::enter(Ref<CollisionDataGD> data) {
	entity->process_event(CollisionEnteredEntityEvent::create(entity, data));
}

void ComponentStaticBody3D::oneshot(Ref<CollisionDataGD> data) {
	entity->process_event(CollisionOneshotEntityEvent::create(entity, data));
}

void ComponentStaticBody3D::exit(Ref<CollisionDataGD> data) {
	entity->process_event(CollisionExitEntityEvent::create(entity, data));
}

void ComponentStaticBody3D::cset_collision_mask_value(int value, bool on) {
	if (get_collision_mask() == 0 && on) {
		set_deferred("monitoring", true);
	}
	set_collision_mask_value(value, on);
	if (get_collision_mask() == 0) {
		set_deferred("monitoring", false);
	}
}

void ComponentStaticBody3D::cset_collision_layer_value(int value, bool on) {
	if (get_collision_layer() == 0 && on) {
		set_deferred("monitorable", true);
	}
	set_collision_layer_value(value, on);
	if (get_collision_layer() == 0) {
		set_deferred("monitorable", false);
	}
}