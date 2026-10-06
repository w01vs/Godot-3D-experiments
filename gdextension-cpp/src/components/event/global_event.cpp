#include "global_event.hpp"

void GlobalEventGD::_bind_methods() {
    
}

Ref<GlobalEventGD> GlobalEventGD::create(Node* p_source) {
    return EventBase::create(p_source);
}