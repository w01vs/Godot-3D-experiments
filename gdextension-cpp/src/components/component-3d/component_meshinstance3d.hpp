#pragma once

#include <godot_cpp/classes/mesh_instance3d.hpp>
#include "../entity.hpp"

using namespace godot;

class ComponentMeshInstance3D : public MeshInstance3D {
	GDCLASS(ComponentMeshInstance3D, MeshInstance3D);

public:
	ComponentMeshInstance3D() = default;
	~ComponentMeshInstance3D() = default;

	void set_entity(Entity *p_entity) { entity = p_entity; }
	Entity *get_entity() const { return entity; }
protected:
	static void _bind_methods();

private:
	Entity *entity = nullptr;
};