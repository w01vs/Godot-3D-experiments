#include "collision_exit_event.hpp"
#include "godot_cpp/core/class_db.hpp"

void CollisionExitEntityEvent::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_data", "data"),&CollisionExitEntityEvent::set_data);
    ClassDB::bind_method(D_METHOD("get_data"), &CollisionExitEntityEvent::get_data);
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "data", PROPERTY_HINT_RESOURCE_TYPE, "CollisionDataGD"), "set_data", "get_data");
}