#include "global_event.hpp"

Ref<GlobalEventGD> GlobalEventGD::create(const Ref<Node>& p_source) {
    return EventBase::create(p_source);
}