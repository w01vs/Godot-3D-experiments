#pragma once

#include "event_base.hpp"

class GlobalEventGD : public EventBase {
    GDCLASS(GlobalEventGD, EventBase)

    public:
        GlobalEventGD() = default;
        ~GlobalEventGD() = default;
    
        static Ref<GlobalEventGD> create(const Ref<Node>& p_source);
};