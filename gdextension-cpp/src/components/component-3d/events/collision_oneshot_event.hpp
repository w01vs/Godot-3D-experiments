#pragma once

#include "../../event/entity_event.hpp"
#include "../collision_data.hpp"

class CollisionOneshotEntityEvent : public EntityEventGD {
	GDCLASS(CollisionOneshotEntityEvent, EntityEventGD);

public:
	Ref<CollisionDataGD> data;

	Ref<CollisionDataGD> get_data() const { return data; }
	void set_data(Ref<CollisionDataGD> p_data) { data = p_data; }

	static Ref<CollisionOneshotEntityEvent> create(Node* p_source, Ref<CollisionDataGD> p_data);

protected:
	static void _bind_methods();
};