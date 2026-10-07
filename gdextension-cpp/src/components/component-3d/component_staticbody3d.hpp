#pragma once

#include "../entity.hpp"
#include "collision_data.hpp"
#include <godot_cpp/classes/static_body3d.hpp>

using namespace godot;

class ComponentStaticBody3D : public StaticBody3D {
	GDCLASS(ComponentStaticBody3D, StaticBody3D);

public:
	ComponentStaticBody3D() = default;
	~ComponentStaticBody3D() = default;

	void _ready() override;
	void enter(Ref<CollisionDataGD> data);
	void oneshot(Ref<CollisionDataGD> data);
	void exit(Ref<CollisionDataGD> data);

	void cset_collision_layer_value(int value, bool on);
	void cset_collision_mask_value(int value, bool on);

	void set_entity(Entity *p_entity) { entity = p_entity; }
	Entity *get_entity() const { return entity; }

protected:
	static void _bind_methods();

private:
	Entity *entity = nullptr;
};