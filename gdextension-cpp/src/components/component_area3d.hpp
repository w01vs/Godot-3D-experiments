#pragma once

#include <godot_cpp/classes/area3d.hpp>

using namespace godot;

class ComponentArea3D : public Area3D {
    GDCLASS(ComponentArea3D, Area3D)

    protected:
        static void _bind_methods();
};