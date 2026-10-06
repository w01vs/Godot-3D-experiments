#include "component_area3d.hpp"
#include "../component.hpp"
#include "collision_data.hpp"
#include "events/collision_entered_event.hpp"
#include "events/collision_exit_event.hpp"
#include "events/collision_oneshot_event.hpp"
#include "godot_cpp/classes/node.hpp"
#include "godot_cpp/variant/utility_functions.hpp"
#include <godot_cpp/classes/engine.hpp>

void ComponentArea3D::_bind_methods() {
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
	Ref<CollisionEnteredEntityEvent> event;
	event.instantiate();
	event->set_source(entity);
	event->set_data(data);
	entity->emit_local(event);
}

void ComponentArea3D::oneshot(Ref<CollisionDataGD> data) {
	Ref<CollisionOneshotEntityEvent> event;
	event.instantiate();
	event->set_source(entity);
	event->set_data(data);
	entity->emit_local(event);
}

void ComponentArea3D::exit(Ref<CollisionDataGD> data) {
	Ref<CollisionExitEntityEvent> event;
	event.instantiate();
	event->set_source(entity);
	event->set_data(data);
	entity->emit_local(event);
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
