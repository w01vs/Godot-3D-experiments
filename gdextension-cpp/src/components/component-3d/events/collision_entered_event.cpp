#include "collision_entered_event.hpp"
#include "godot_cpp/core/class_db.hpp"

void CollisionEnteredEntityEvent::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_data", "data"),&CollisionEnteredEntityEvent::set_data);
    ClassDB::bind_method(D_METHOD("get_data"), &CollisionEnteredEntityEvent::get_data);
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "data", PROPERTY_HINT_RESOURCE_TYPE, "CollisionDataGD"), "set_data", "get_data");

    ClassDB::bind_static_method("CollisionEnteredEntityEvent",D_METHOD("create", "source", "data"), &CollisionEnteredEntityEvent::create);
}

Ref<CollisionEnteredEntityEvent> CollisionEnteredEntityEvent::create(Node* p_source, Ref<CollisionDataGD> p_data) {
    Ref<CollisionEnteredEntityEvent> event = memnew(CollisionEnteredEntityEvent);
    event->data = p_data;
    event->source = p_source;

    return event;
}