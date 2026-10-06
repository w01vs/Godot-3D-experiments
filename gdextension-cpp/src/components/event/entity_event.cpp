#include "entity_event.hpp"

void EntityEventGD::_bind_methods() {
    
}

Ref<EntityEventGD> EntityEventGD::create(Node* p_source) {
    Ref<EventBaseGD> event = EventBaseGD::create(p_source);
    Ref<EntityEventGD> final = event;
    final->type = final->get_script();

    return final;
}