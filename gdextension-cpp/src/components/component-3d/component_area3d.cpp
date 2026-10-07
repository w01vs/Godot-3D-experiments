#include "component_area3d.hpp"
#include "../component.hpp"
#include "collision_data.hpp"
#include "events/collision_entered_event.hpp"
#include "events/collision_exit_event.hpp"
#include "events/collision_oneshot_event.hpp"
#include "godot_cpp/classes/node.hpp"
#include "godot_cpp/core/class_db.hpp"
#include "godot_cpp/core/property_info.hpp"
#include "godot_cpp/variant/utility_functions.hpp"
#include <godot_cpp/classes/engine.hpp>

void ComponentArea3D::_bind_methods() {
	ClassDB::bind_method(D_METHOD("enter", " data"), &ComponentArea3D::enter);
	ClassDB::bind_method(D_METHOD("oneshot", " data"), &ComponentArea3D::oneshot);
	ClassDB::bind_method(D_METHOD("exit", " data"), &ComponentArea3D::exit);

	ClassDB::bind_method(D_METHOD("cset_collision_layer_value", "value", "on"), &ComponentArea3D::cset_collision_layer_value);
	ClassDB::bind_method(D_METHOD("cset_collision_mask_value", "value", "on"), &ComponentArea3D::cset_collision_mask_value);

	ClassDB::bind_method(D_METHOD("get_entity"),&ComponentArea3D::get_entity);
	ClassDB::bind_method(D_METHOD("set_entity"),&ComponentArea3D::set_entity);
	ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "entity", PROPERTY_HINT_NODE_TYPE, "Entity"), "set_entity", "get_entity");
}

void ComponentArea3D::_ready() {
	if (!Engine::get_singleton()->is_editor_hint()) {
		assert(entity);
		set_collision_layer(0);
		set_collision_mask(0);
		set_deferred("monitorable", false);
		set_deferred("monitoring", false);
		add_to_group(Component::GROUP);
	}

	TypedArray<Node> nodes = find_children("*", "CollisionShape3D", true, true);
	for (auto node : nodes) {
		shapes.append(node);
	}
	if (shapes.size() > 1) {
		UtilityFunctions::push_warning("ComponentArea3D with more than 1 CollisionShape3D at %s", UtilityFunctions::str(this));
	}
}

void ComponentArea3D::enter(Ref<CollisionDataGD> data) {
	entity->process_event(CollisionEnteredEntityEvent::create(entity, data));
}

void ComponentArea3D::oneshot(Ref<CollisionDataGD> data) {
	entity->process_event(CollisionOneshotEntityEvent::create(entity, data));
}

void ComponentArea3D::exit(Ref<CollisionDataGD> data) {
	entity->process_event(CollisionExitEntityEvent::create(entity, data));
}

void ComponentArea3D::cset_collision_mask_value(int value, bool on) {
	if (get_collision_mask() == 0 && on) {
		set_deferred("monitoring", true);
	}
	set_collision_mask_value(value, on);
	if (get_collision_mask() == 0) {
		set_deferred("monitoring", false);
	}
}

void ComponentArea3D::cset_collision_layer_value(int value, bool on) {
	if (get_collision_layer() == 0 && on) {
		set_deferred("monitorable", true);
	}
	set_collision_layer_value(value, on);
	if (get_collision_layer() == 0) {
		set_deferred("monitorable", false);
	}
}
