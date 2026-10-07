#pragma once

#include "../../event/entity_event.hpp"
#include <godot_cpp/classes/wrapped.hpp>

class RayCastEntityEvent : public EntityEventGD {
	GDCLASS(RayCastEntityEvent, EntityEventGD);

public:
	RayCastEntityEvent() = default;
	~RayCastEntityEvent() = default;
	Object *collider;

	Object *get_collider() const { return collider; }
	void set_collider(Object *p_collider) { collider = p_collider; }

	static Ref<RayCastEntityEvent> create(Node *p_source, Object *p_collider);

protected:
	static void _bind_methods();
};