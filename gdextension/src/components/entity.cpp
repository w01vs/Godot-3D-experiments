#include "entity.hpp"
#include "component.hpp"

void Entity::_ready() {
    event_bus.enable();
    event_bus.release_events();
}

void Entity::register_component(Ref<Component> component) {
    for(Ref<Script> script : find_bases(component->get_script())) {
        component_map.set(script, component);
    }
}

Ref<Component> Entity::get_component(Ref<Script> script) {
    return component_map.get(script, Variant());
}

bool Entity::has_component(Ref<Script> script) {
    return component_map.has(script);
}

void Entity::remove_component(Ref<Component> component) {
    for(Ref<Script> script : find_bases(component->get_script())) {
        if(get_component(script) == component)
            component_map.erase(component->get_script());
    }

    for(Ref<Script> event : global_subscriptions.keys()) {
        TypedArray<Callable> callbacks = global_subscriptions.get(event, Variant());
        for(int i = callbacks.size(); i >= 0; i--)
        {
            Ref<Callable> cb = callbacks.get(i);
            if(cb.is_valid() && Object::cast_to<Component>(cb->get_object()) == component.ptr()){
                callbacks[i] = callbacks[callbacks.size() - 1];
                callbacks.pop_back();
                if(callbacks.size() == 0) {
                    global_subscriptions.erase(event);
                }
            }
        }
    }
}