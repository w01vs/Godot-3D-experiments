#include "utils.hpp"
#include "gdextension_interface.h"
#include "godot_cpp/variant/utility_functions.hpp"

StringName Utils::get_native_class_name(const Variant &p_type) {
    UtilityFunctions::push_warning(
        "get_native_class_name(): type = ",
        p_type
    );

    if (p_type.get_type() == Variant::STRING ||
        p_type.get_type() == Variant::STRING_NAME) {

        StringName class_name = StringName(p_type);

        UtilityFunctions::push_warning(
            "get_native_class_name(): string -> ",
            class_name
        );
        return class_name;
    }

    if (p_type.get_type() == Variant::OBJECT) {
        Object *obj = Object::cast_to<Object>(p_type);
        // I CANNOT DETERMINE THE TYPE OF THIS OBJECT ITS JUST FUCKIGN GDSCRIPTNATIVECLASS RAAAAAAAAHHHHHHH

        if (obj) {
            StringName class_name = obj->get_class();

            UtilityFunctions::push_warning(
                "get_native_class_name(): object -> ",
                class_name
            );

            return class_name;
        }
    }

    UtilityFunctions::push_warning(
        "get_native_class_name(): could not resolve type"
    );

    return StringName();
}


bool Utils::inherits(const Variant &p_parent, const Variant &p_child) {
    Ref<Script> parent_script = Object::cast_to<Script>(p_parent);
    Ref<Script> child_script = Object::cast_to<Script>(p_child);

    // script -> script
    if (parent_script.is_valid() && child_script.is_valid()) {
        for (Ref<Script> current = child_script;
             current.is_valid();
             current = current->get_base_script()) {

            if (current == parent_script) {
                return true;
            }
        }

        return false;
    }

    // native -> script
    if (parent_script.is_valid() && !child_script.is_valid()) {
        return false;
    }

    // Resolve parent as native.
    StringName parent_native = get_native_class_name(p_parent);

    if (parent_native.is_empty()) {
        return false;
    }

    // script -> native
    if (child_script.is_valid()) {
        StringName child_base = child_script->get_instance_base_type();

        const bool result =
            child_base == parent_native ||
            ClassDB::is_parent_class(child_base, parent_native);

        return result;
    }

    // native -> native
    StringName child_native = get_native_class_name(p_child);

    if (child_native.is_empty()) {
        return false;
    }

    const bool result =
        child_native == parent_native ||
        ClassDB::is_parent_class(child_native, parent_native);
    return result;
}