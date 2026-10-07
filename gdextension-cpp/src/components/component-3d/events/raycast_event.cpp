#include "raycast_event.hpp"

void RayCastEntityEvent::_bind_methods() {
	ClassDB::bind_method(D_METHOD("set_collider", "collider"), &RayCastEntityEvent::set_collider);
	ClassDB::bind_method(D_METHOD("get_collider"), &RayCastEntityEvent::get_collider);
	ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "collider"), "set_collider", "get_collider");

	ClassDB::bind_static_method("RayCastEntityEvent", D_METHOD("create", "source", "data"), &RayCastEntityEvent::create);
}

Ref<RayCastEntityEvent> RayCastEntityEvent::create(Node *p_source, Object *p_collider) {
    Ref<RayCastEntityEvent> event = memnew(RayCastEntityEvent);
    event->source = p_source;
    event->collider = p_collider;

    return event;
}