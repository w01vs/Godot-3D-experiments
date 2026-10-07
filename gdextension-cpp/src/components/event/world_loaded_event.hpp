#pragma once

#include "global_event.hpp"

class WorldLoadedEvent : public GlobalEventGD {
    GDCLASS(WorldLoadedEvent, GlobalEventGD);
    public:
        WorldLoadedEvent() = default;
        ~WorldLoadedEvent() = default;

        static Ref<WorldLoadedEvent> create(Node* p_source);
    protected:
        static void _bind_methods();
};