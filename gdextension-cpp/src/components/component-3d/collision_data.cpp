#include "collision_data.hpp"
#include "godot_cpp/core/class_db.hpp"

void CollisionDataGD::_bind_methods() {
    ClassDB::bind_method(D_METHOD("get_source"), &CollisionDataGD::get_source);
    ClassDB::bind_method(D_METHOD("set_source", "source"), &CollisionDataGD::set_source);
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "source", PROPERTY_HINT_NODE_TYPE, "Entity"), "set_source", "get_source");
}