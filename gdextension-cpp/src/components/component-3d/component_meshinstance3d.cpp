#include "component_meshinstance3d.hpp"

void ComponentMeshInstance3D::_bind_methods() {
	ClassDB::bind_method(D_METHOD("get_entity"),&ComponentMeshInstance3D::get_entity);
	ClassDB::bind_method(D_METHOD("set_entity"),&ComponentMeshInstance3D::set_entity);
	ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "entity", PROPERTY_HINT_NODE_TYPE, "Entity"), "set_entity", "get_entity");
}