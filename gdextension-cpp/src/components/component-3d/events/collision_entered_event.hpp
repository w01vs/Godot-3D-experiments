#pragma once

#include "../../event/entity_event.hpp"
#include "../collision_data.hpp"

class CollisionEnteredEntityEvent : public EntityEventGD {
	GDCLASS(CollisionEnteredEntityEvent, EntityEventGD);

public:
	Ref<CollisionDataGD> data;

	Ref<CollisionDataGD> get_data() const { return data; }
	void set_data(Ref<CollisionDataGD> p_data) { data = p_data; }

protected:
	static void _bind_methods();
};