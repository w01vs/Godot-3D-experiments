#pragma once

#include <godot_cpp/classes/script.hpp>

using namespace godot;

class Utils {

public:
static bool inherits(const Variant& parent, const Variant& child);
static StringName get_native_class_name(const Variant& p_type);

};