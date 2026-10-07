#include "collision_oneshot_event.hpp"
#include "godot_cpp/core/class_db.hpp"

void CollisionOneshotEntityEvent::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_data", "data"),&CollisionOneshotEntityEvent::set_data);
    ClassDB::bind_method(D_METHOD("get_data"), &CollisionOneshotEntityEvent::get_data);
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "data", PROPERTY_HINT_RESOURCE_TYPE, "CollisionDataGD"), "set_data", "get_data");

    ClassDB::bind_static_method("CollisionOneshotEntityEvent", D_METHOD("create", "source", "data"), &CollisionOneshotEntityEvent::create);
}

Ref<CollisionOneshotEntityEvent> CollisionOneshotEntityEvent::create(Node* p_source, Ref<CollisionDataGD> p_data) {
    CollisionOneshotEntityEvent* event = memnew(CollisionOneshotEntityEvent);
    event->data = p_data;
    event->source = p_source;

    return Ref<CollisionOneshotEntityEvent>(event);
}