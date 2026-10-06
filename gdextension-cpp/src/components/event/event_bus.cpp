#include "event_bus.hpp"
#include "../component.hpp"
#include "../utils/utils.hpp"
#include "godot_cpp/variant/utility_functions.hpp"

EventBus::EventBus() {
	truth = Callable{ this, "always_true" };
}

EventBus* EventBus::get_singleton() {
	if (!instance) {
		instance = memnew(EventBus);
	}
	return instance;
}

void EventBus::start() {
	event_bus->enable();
	event_bus->release_events();
}

bool EventBus::always_true() {
	return true;
}

void EventBus::subscribe(const Ref<Script> &event_type, const Callable &callback, EventBusBase::Priority priority, const Callable &condition) {
	assert(!Object::cast_to<Component>(callback.get_object()));
	assert(Utils::is_of_type(event_type, BASE_EVENT_SCRIPT));
	if (Object::cast_to<Component>(callback.get_object()) || Utils::is_of_type(event_type, BASE_EVENT_SCRIPT)) {
		UtilityFunctions::push_error("Called from component or supplied wrong event type");
		return;
	}
	event_bus->subscribe(event_type, callback, condition, priority);
}

void EventBus::unsubscribe(const Ref<Script> &event_type, const Callable &callback) {
    assert(!Object::cast_to<Component>(callback.get_object()));
    assert(Utils::is_of_type(event_type, BASE_EVENT_SCRIPT));
	if (Object::cast_to<Component>(callback.get_object()) || Utils::is_of_type(event_type, BASE_EVENT_SCRIPT)) {
		UtilityFunctions::push_error("Called from component or supplied wrong event type");
		return;
	}
    event_bus->unsubscribe(event_type, callback);
}

void EventBus::emit(const Ref<EventBase> &event) {
    if(Object::cast_to<Component>(event->get_source())) {
        UtilityFunctions::push_error("You cannot emit a global event from a component");
        return;
    }
    event_bus->emit(event);
}