#include "event_base.hpp"

void EventBase::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_source", "source"), &EventBase::set_source);
    ClassDB::bind_method(D_METHOD("get_source"), &EventBase::get_source);
    ClassDB::bind_method(D_METHOD("get_debug_id"), &EventBase::get_debug_id);

    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "source", PROPERTY_HINT_RESOURCE_TYPE, "Node"), "set_source", "get_source");
}

Ref<EventBase> EventBase::create(Ref<Node> p_source) {
    Ref<EventBase> event;
    event.instantiate();
    event->source = p_source;
    Ref<Script> script = event->get_script();
    if(!script.is_null())
        event->debug_id = script->get_instance_id();

    return event;
}