#pragma once

#include "event_bus_base.hpp"
#include "godot_cpp/classes/node.hpp"
#include <cassert>

using namespace godot;

class EventBus : public Node {
	GDCLASS(EventBus, Node)
public:
	static EventBus* get_singleton();

	static void start(Node* source);
    static void subscribe(const Variant &event_type, const Callable &callback, EventBusBase::Priority priority = EventBusBase::Priority::BASE, const Callable &condition = get_singleton()->truth);
    static void unsubscribe(const Variant &event_type, const Callable &callback);
    static void emit(const Ref<EventBaseGD> &event);

protected:
    static void _bind_methods();

private:
	Ref<EventBusBase> event_bus;
	static EventBus* instance;
	Callable truth;

	EventBus();
	~EventBus() = default;


	bool always_true();
};