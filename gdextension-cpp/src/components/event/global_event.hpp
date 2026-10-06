#pragma once

#include "event_base.hpp"

class GlobalEventGD : public EventBaseGD {
    GDCLASS(GlobalEventGD, EventBaseGD)

    public:
        GlobalEventGD() = default;
        ~GlobalEventGD() = default;
    
        static Ref<GlobalEventGD> create(Node* p_source);
    
    protected:
        static void _bind_methods();
};