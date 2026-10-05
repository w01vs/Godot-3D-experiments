#include "entity_event.hpp"

Ref<EntityEventGD> EntityEventGD::create(const Ref<Node>& p_source) {
    Ref<EventBase> event = EventBase::create(p_source);
    Ref<EntityEventGD> final = event;
    final->type = final->get_script();

    return final;
}