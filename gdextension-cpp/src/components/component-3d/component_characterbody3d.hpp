
#pragma once

#include "../entity.hpp"
#include "godot_cpp/classes/character_body3d.hpp"

using namespace godot;

class ComponentCharacterBody3D : public CharacterBody3D {
	GDCLASS(ComponentCharacterBody3D, CharacterBody3D);

public:
	ComponentCharacterBody3D() = default;
	~ComponentCharacterBody3D() = default;

	void set_entity(Entity *p_entity) { entity = p_entity; }
	Entity *get_entity() const { return entity; }

    void _ready() override;
    void _physics_process(double delta) override;

	void cset_collision_layer_value(int value, bool on);
	void cset_collision_mask_value(int value, bool on);
protected:
	static void _bind_methods();

private:
	Entity *entity = nullptr;
};