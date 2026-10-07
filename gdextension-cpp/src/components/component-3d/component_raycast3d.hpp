#pragma once

#include "../entity.hpp"
#include <godot_cpp/classes/ray_cast3d.hpp>

using namespace godot;

class ComponentRayCast3D : public RayCast3D {
	GDCLASS(ComponentRayCast3D, RayCast3D);

public:
	ComponentRayCast3D() = default;
	~ComponentRayCast3D() = default;

	void _ready() override;
	void _physics_process();
	const Object *get_current_collider();

	void set_area_collision(bool on);
	void set_body_collision(bool on);

	void cset_collision_mask_value(int value, bool on);

	void enable();
	void disable();

	void set_entity(Entity *p_entity) { entity = p_entity; }
	Entity *get_entity() const { return entity; }

protected:
	static void _bind_methods();

private:
	Entity *entity = nullptr;
    Object* current_collider = nullptr;
};