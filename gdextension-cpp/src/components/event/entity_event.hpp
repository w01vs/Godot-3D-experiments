#pragma once

#include "event_base.hpp"
#include "godot_cpp/classes/node.hpp"

class EntityEventGD : public EventBaseGD {
	GDCLASS(EntityEventGD, EventBaseGD)

private:
	Ref<Script> type;
	static Ref<EntityEventGD> create(Node *p_source);

protected:
	static void _bind_methods();

public:
	EntityEventGD() = default;
	~EntityEventGD() = default;
};