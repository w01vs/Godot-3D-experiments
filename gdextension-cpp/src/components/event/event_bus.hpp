#pragma once

#include "event_bus_base.hpp"
#include "godot_cpp/classes/node.hpp"
#include <cassert>

using namespace godot;

class EventBus : public Node {
	GDCLASS(EventBus, Node)
public:
	static EventBus* get_singleton();
	static Ref<Script> BASE_EVENT_SCRIPT;

	static void start();
    static void subscribe(const Ref<Script> &event_type, const Callable &callback, EventBusBase::Priority priority = EventBusBase::Priority::BASE, const Callable &condition = truth);
    static void unsubscribe(const Ref<Script> &event_type, const Callable &callback);
    static void emit(const Ref<EventBase> &event);

protected:
    static void _bind_methods();

private:
	static Ref<EventBusBase> event_bus;
	static EventBus* instance;
	static Callable truth;

	EventBus();
	~EventBus() = default;


	static bool always_true();
};