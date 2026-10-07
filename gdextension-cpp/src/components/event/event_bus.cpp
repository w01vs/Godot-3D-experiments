#include "event_bus.hpp"
#include "../component.hpp"
#include "godot_cpp/core/class_db.hpp"
#include "godot_cpp/variant/utility_functions.hpp"
#include <godot_cpp/core/class_db.hpp>
 
EventBus* EventBus::instance = nullptr;
Ref<Script> EventBus::BASE_EVENT_SCRIPT = nullptr;

void EventBus::_bind_methods() {
	ClassDB::bind_static_method("EventBus", D_METHOD("start"), &EventBus::start);
	ClassDB::bind_static_method("EventBus", D_METHOD("subscribe", "event_type", "callback", "priority", "condition"), &EventBus::subscribe, DEFVAL(get_singleton()->truth), DEFVAL(EventBusBase::Priority::BASE));
	ClassDB::bind_static_method("EventBus", D_METHOD("unsubscribe", "event_type", "callback"), &EventBus::unsubscribe);
	ClassDB::bind_static_method("EventBus", D_METHOD("emit", "event"), &EventBus::emit);
}

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
	get_singleton()->event_bus->enable();
	get_singleton()->event_bus->release_events();
}

bool EventBus::always_true() {
	return true;
}

void EventBus::subscribe(const Variant &event_type, const Callable &callback, EventBusBase::Priority priority, const Callable &condition) {
    assert(!Object::cast_to<Component>(callback.get_object()));
	Ref<Script> script = Object::cast_to<Script>(event_type);
	assert(script.ptr());
	if(!script.ptr()){
		UtilityFunctions::push_error("Supplied an invalid event type.");
		return;
	}
	bool inherits = ClassDB::is_parent_class(script->get_class_static(), BASE_EVENT_SCRIPT->get_class_static());
    assert(inherits);
	if (Object::cast_to<Component>(callback.get_object()) || !inherits) {
		UtilityFunctions::push_error("Called from component or supplied wrong event type");
		return;
	}
	get_singleton()->event_bus->subscribe(event_type, callback, condition, priority);
}

void EventBus::unsubscribe(const Variant &event_type, const Callable &callback) {
    assert(!Object::cast_to<Component>(callback.get_object()));
	Ref<Script> script = Object::cast_to<Script>(event_type);
	assert(script.ptr());
	if(!script.ptr()){
		UtilityFunctions::push_error("Supplied an invalid event type.");
		return;
	}
	bool inherits = ClassDB::is_parent_class(script->get_class_static(), BASE_EVENT_SCRIPT->get_class_static());
    assert(inherits);
	if (Object::cast_to<Component>(callback.get_object()) || !inherits) {
		UtilityFunctions::push_error("Called from component or supplied wrong event type");
		return;
	}
    get_singleton()->event_bus->unsubscribe(event_type, callback);
}

void EventBus::emit(const Ref<EventBaseGD> &event) {
    if(Object::cast_to<Component>(event->get_source())) {
        UtilityFunctions::push_error("You cannot emit a global event from a component");
        return;
    }
    get_singleton()->event_bus->emit(event);
}