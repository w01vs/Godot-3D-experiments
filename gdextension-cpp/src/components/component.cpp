#include "component.hpp"
#include "godot_cpp/classes/wrapped.hpp"

void Component::_bind_methods() {
    GDVIRTUAL_BIND(_on_entity_load)
}
void Component::_ready() {
    assert(entity);
    assert(entity->is_ancestor_of(this));
    entity->register_component(this);
}

void Component::_on_entity_load() {
    if(!GDVIRTUAL_IS_OVERRIDDEN(_on_entity_load)) {
        return;
    }
    else{
        GDVIRTUAL_CALL(_on_entity_load);
    }
}