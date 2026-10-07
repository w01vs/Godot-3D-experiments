#include "component_raycast3d.hpp"
#include "../component.hpp"
#include "events/raycast_event.hpp"


void ComponentRayCast3D::_bind_methods() {
	ClassDB::bind_method(D_METHOD("cset_collision_mask_value", "value", "on"), &ComponentRayCast3D::cset_collision_mask_value);
	ClassDB::bind_method(D_METHOD("get_entity"),&ComponentRayCast3D::get_entity);
	ClassDB::bind_method(D_METHOD("set_entity"),&ComponentRayCast3D::set_entity);
	ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "entity", PROPERTY_HINT_NODE_TYPE, "Entity"), "set_entity", "get_entity");
}

void ComponentRayCast3D::_ready() {
    assert(entity);
    set_collision_mask(0);
    set_area_collision(false);
    set_body_collision(false);
    add_to_group(Component::GROUP);
}

void ComponentRayCast3D::_physics_process(double delta) {
    Object* collider = get_collider();
    if(current_collider != collider) {
        current_collider = collider;
        entity->process_event(RayCastEntityEvent::create(entity, current_collider));
    }
    else if(current_collider){
        current_collider = nullptr;
    }
}

const Object* ComponentRayCast3D::get_current_collider() {
    return current_collider;
}

void ComponentRayCast3D::set_area_collision(bool on) {
    set_collide_with_areas(on);
}

void ComponentRayCast3D::set_body_collision(bool on) {
    set_collide_with_bodies(on);
}


void ComponentRayCast3D::cset_collision_mask_value(int value, bool on) {
	if (get_collision_mask() == 0 && on) {
        enable();
	}
	set_collision_mask_value(value, on);
	if (get_collision_mask() == 0) {
        disable();
	}
}

void ComponentRayCast3D::enable() {
    set_enabled(true);
}

void ComponentRayCast3D::disable() {
    set_enabled(false);
}
