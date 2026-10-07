#include "component_characterbody3d.hpp"
#include "../component.hpp"
#include "godot_cpp/variant/transform3d.hpp"

void ComponentCharacterBody3D::_bind_methods() {
	ClassDB::bind_method(D_METHOD("get_entity"),&ComponentCharacterBody3D::get_entity);
	ClassDB::bind_method(D_METHOD("set_entity"),&ComponentCharacterBody3D::set_entity);
	ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "entity", PROPERTY_HINT_NODE_TYPE, "Entity"), "set_entity", "get_entity");

	ClassDB::bind_method(D_METHOD("cset_collision_layer_value", "value", "on"), &ComponentCharacterBody3D::cset_collision_layer_value);
	ClassDB::bind_method(D_METHOD("cset_collision_mask_value", "value", "on"), &ComponentCharacterBody3D::cset_collision_mask_value);
}

void ComponentCharacterBody3D::_ready() {
    set_collision_layer(0);
    set_collision_mask(0);
    add_to_group(Component::GROUP);
}

void ComponentCharacterBody3D::_physics_process(double delta) {
    move_and_slide();
    entity->set_global_transform(get_global_transform());
    set_transform(Transform3D{});
}

void ComponentCharacterBody3D::cset_collision_mask_value(int value, bool on) {
	if (get_collision_mask() == 0 && on) {
		set_deferred("monitoring", true);
	}
	set_collision_mask_value(value, on);
	if (get_collision_mask() == 0) {
		set_deferred("monitoring", false);
	}
}

void ComponentCharacterBody3D::cset_collision_layer_value(int value, bool on) {
	if (get_collision_layer() == 0 && on) {
		set_deferred("monitorable", true);
	}
	set_collision_layer_value(value, on);
	if (get_collision_layer() == 0) {
		set_deferred("monitorable", false);
	}
}