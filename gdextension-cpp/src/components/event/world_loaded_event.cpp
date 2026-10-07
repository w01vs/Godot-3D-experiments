#include "world_loaded_event.hpp"

void WorldLoadedEvent::_bind_methods() {
    ClassDB::bind_static_method("WorldLoadedEvent", D_METHOD("create", "source"), &WorldLoadedEvent::create);   
}

Ref<WorldLoadedEvent> WorldLoadedEvent::create(Node *p_source) {
    Ref<WorldLoadedEvent> event = memnew(WorldLoadedEvent);
    event->source = p_source;

    return event;
}