#pragma once

#include "../entity.hpp"
#include "godot_cpp/classes/resource.hpp"

using namespace godot;

class CollisionDataGD : public Resource {
	GDCLASS(CollisionDataGD, Resource);

public:
    CollisionDataGD() = default;
    ~CollisionDataGD() = default;
    
	Entity *source = nullptr;
	Entity *get_source() const { return source; }
	void set_source(Entity *p_source) { source = p_source; }
protected:
    static void _bind_methods();
};