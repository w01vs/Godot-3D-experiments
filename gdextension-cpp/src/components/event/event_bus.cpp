#include "event_bus.hpp"
#include "../component.hpp"
#include "components/event/event_bus_base.hpp"
#include "components/event/global_event.hpp"
#include "components/event/world_loaded_event.hpp"
#include "godot_cpp/classes/project_settings.hpp"
#include "godot_cpp/core/class_db.hpp"
#include "godot_cpp/variant/utility_functions.hpp"
#include <godot_cpp/core/class_db.hpp>
#include "../utils/utils.hpp"

EventBus *EventBus::instance = nullptr;

void EventBus::_bind_methods() {
	ClassDB::bind_static_method("EventBus", D_METHOD("start"), &EventBus::start);
	ClassDB::bind_static_method("EventBus", D_METHOD("subscribe", "event_type", "callback", "priority", "condition"), &EventBus::subscribe, DEFVAL(EventBusBase::Priority::BASE), DEFVAL(get_singleton()->truth));
	ClassDB::bind_static_method("EventBus", D_METHOD("unsubscribe", "event_type", "callback"), &EventBus::unsubscribe);
	ClassDB::bind_static_method("EventBus", D_METHOD("emit", "event"), &EventBus::emit);
}

EventBus::EventBus() {
	truth = Callable{ this, "always_true" };
	event_bus = memnew(EventBusBase);
}

EventBus *EventBus::get_singleton() {
	if (!instance) {
		instance = memnew(EventBus);
	}
	return instance;
}

void EventBus::start(Node *source) {
	get_singleton()->event_bus->enable();
	get_singleton()->event_bus->release_events();
	emit(WorldLoadedEvent::create(source));
}

bool EventBus::always_true() {
	return true;
}

void EventBus::subscribe(const Variant &event_type, const Callable &callback, EventBusBase::Priority priority, const Callable &condition) {
	GDASSERT(!Object::cast_to<Component>(callback.get_object()), "Cannot directly use EventBus from Component subtypes");
	GDASSERT(EventBaseGD::validate_event_script(event_type), "Supplied a type that is not an event type. The event type needs to inherit from EventBaseGD, GlobalEventGD or EntityEventGD");
	if (!EventBaseGD::validate_event_script(event_type)) {
		UtilityFunctions::push_error("Supplied a type that is not an event type. The event type needs to inherit from EventBaseGD, GlobalEventGD or EntityEventGD");
		return;
	}
	bool inherits = Utils::inherits(GlobalEventGD::get_class_static(), event_type);
	GDASSERT(inherits, "EventBus events need to derive from GlobalEventGD");
	if(!inherits) {
		UtilityFunctions::push_error("EventBus events need to derive from GlobalEventGD");
		return;
	}
	get_singleton()->event_bus->subscribe(event_type, callback, condition, priority);
}

void EventBus::unsubscribe(const Variant &event_type, const Callable &callback) {
	GDASSERT(!Object::cast_to<Component>(callback.get_object()), "Cannot directly use EventBus from Component subtypes");
	GDASSERT(EventBaseGD::validate_event_script(event_type), "Supplied a type that is not an event type. The event type needs to inherit from EventBaseGD, GlobalEventGD or EntityEventGD");
	if (!EventBaseGD::validate_event_script(event_type)) {
		UtilityFunctions::push_error("Supplied a type that is not an event type. The event type needs to inherit from EventBaseGD, GlobalEventGD or EntityEventGD");
		return;
	}
	bool inherits = Utils::inherits(GlobalEventGD::get_class_static(), event_type);
	GDASSERT(inherits, "EventBus events need to derive from GlobalEventGD");
	if(!inherits) {
		UtilityFunctions::push_error("EventBus events need to derive from GlobalEventGD");
		return;
	}
	get_singleton()->event_bus->unsubscribe(event_type, callback);
}

void EventBus::emit(const Ref<EventBaseGD> &event) {
	if (Object::cast_to<Component>(event->get_source())) {
		UtilityFunctions::push_error("You cannot emit a global event from a component");
		return;
	}
	get_singleton()->event_bus->emit(event);
}