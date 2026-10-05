#include "event_bus.hpp"
#include "../component.hpp"

EventBus::EventBus(){
    truth = Callable{this, "always_true"};
}

Ref<EventBus> EventBus::get_singleton() {
    if(!instance.ptr()) 
        instance.instantiate();
    return instance;
}

void EventBus::start() {
    event_bus->enable();
    event_bus->release_events();
}

bool EventBus::always_true() {
    return true;
}

void EventBus::subscribe(const Ref<Script>& event_type, const Ref<Callable>& callback, EventBusBase::Priority priority, const Ref<Callable>& condition) {
    assert(!Object::cast_to<Component>(callback->get_object()));
    assert(Utils::is_of_type(event_type, BASE_EVENT_SCRIPT));
    event_bus->subscribe(event_type, callback, condition, priority);
}