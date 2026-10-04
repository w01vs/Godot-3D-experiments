#include "entity.hpp"
#include "component.hpp"
#include "godot_cpp/variant/typed_array.hpp"
#include "godot_cpp/variant/utility_functions.hpp"

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

TypedArray<Script> Entity::find_bases(Ref<Script> p_script, bool removing) {
    Ref<Script> current = p_script;
    TypedArray<Script> scripts = TypedArray<Script>();
    while(Object::cast_to<Component>(current.ptr())) {
        assert(!component_map.has(current) || removing);
        if (component_map.has(current) && !removing) {
            UtilityFunctions::push_error("A component of this type %s has already been registered", current->get_global_name());
            return TypedArray<Script>{};
        }
        scripts.append(current);
        current = current->get_base_script();
    }
    return scripts;
}

void Entity::subscribe(Ref<Component> component, Ref<Script> event_type, Ref<Callable> callback, EventBusBase::Priority priority) {

    event_bus.unsubscribe(event_type, callback, component->is_active(), priority);
}

void Entity::unsubscribe() {

}

void Entity::emit_local() {

}

void Entity::emit_global() {

}

void Entity::callback_internal() {

}

void Entity::enable() {
    this->show();
    active = false;
}

void Entity::disable() {
    this->hide();
    active = false;
}

