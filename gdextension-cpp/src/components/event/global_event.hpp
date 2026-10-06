#pragma once

#include "event_base.hpp"

class GlobalEventGD : public EventBase {
    GDCLASS(GlobalEventGD, EventBase)

    public:
        GlobalEventGD() = default;
        ~GlobalEventGD() = default;
    
        static Ref<GlobalEventGD> create(Node* p_source);
    
    protected:
        static void _bind_methods();
};