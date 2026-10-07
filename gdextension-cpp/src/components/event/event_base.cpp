#include "event_base.hpp"
#include "godot_cpp/core/class_db.hpp"

void EventBaseGD::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_source", "source"), &EventBaseGD::set_source);
    ClassDB::bind_method(D_METHOD("get_source"), &EventBaseGD::get_source);
    ClassDB::bind_method(D_METHOD("get_debug_id"), &EventBaseGD::get_debug_id);
    ClassDB::bind_method(D_METHOD("set_debug_id", "debug_id"), &EventBaseGD::set_debug_id);

    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "source", PROPERTY_HINT_NODE_TYPE, "Node"), "set_source", "get_source");
    ADD_PROPERTY(PropertyInfo(Variant::INT, "debug_id"), "set_debug_id", "get_debug_id");
}

Ref<EventBaseGD> EventBaseGD::create(Node* p_source) {
    Ref<EventBaseGD> event;
    event.instantiate();
    event->source = p_source;
    Ref<Script> script = event->get_script();
    if(!script.is_null())
        event->debug_id = script->get_instance_id();

    return event;
}