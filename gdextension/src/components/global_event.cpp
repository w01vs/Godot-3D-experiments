#include "global_event.hpp"

Ref<GlobalEventGD> GlobalEventGD::create(Ref<Node> p_source) {
    return EventBase::create(p_source);
}