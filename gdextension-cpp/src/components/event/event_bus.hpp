#pragma once

#include "event_bus_base.hpp"
#include "godot_cpp/classes/node.hpp"
#include <cassert>

using namespace godot;

class EventBus : public Node {
    GDCLASS(EventBus, Node)
    public:
        static Ref<EventBus> get_singleton();
        static Ref<Script> BASE_EVENT_SCRIPT;

        static void start();

    private:
        static Ref<EventBusBase> event_bus;   
        static Ref<EventBus> instance;
        static Ref<Callable> truth;
    
        EventBus();
        ~EventBus() = default;

        static void subscribe(const Ref<Script>& event_type, const Ref<Callable>& callback, EventBusBase::Priority priority = EventBusBase::Priority::BASE, const Ref<Callable>& condition = truth);
        static void unsubscribe(const Ref<Script>& event_type, const Ref<Callable>& callback);
        static void emit(const Ref<EventBase>& event);

        static bool always_true();
};