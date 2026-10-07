#pragma once

#include "../entity.hpp"
#include "collision_data.hpp"
#include "godot_cpp/classes/collision_shape3d.hpp"
#include <cassert>
#include <godot_cpp/classes/area3d.hpp>

using namespace godot;

class ComponentArea3D : public Area3D {
	GDCLASS(ComponentArea3D, Area3D)

private:
	Entity *entity = nullptr;
	TypedArray<CollisionShape3D> shapes;

protected:
	static void _bind_methods();

public:
	ComponentArea3D() = default;
	~ComponentArea3D() = default;

	void set_entity(Entity *p_entity) { entity = p_entity; }
	Entity *get_entity() const { return entity; }

	void _ready() override;

	void enter(Ref<CollisionDataGD> data);

	void oneshot(Ref<CollisionDataGD> data);

	void exit(Ref<CollisionDataGD> data);

	void cset_collision_mask_value(int value, bool on);
	void cset_collision_layer_value(int value, bool on);
};