#pragma once

#include "event_base.hpp"
#include "godot_cpp/classes/node.hpp"

class EntityEventGD : public EventBase {
    GDCLASS(EntityEventGD, EventBase)

    private:
        Ref<Script> type;
        static Ref<EntityEventGD> create(Ref<Node> p_source);

    public:
        EntityEventGD() = default;
        ~EntityEventGD() = default;
};