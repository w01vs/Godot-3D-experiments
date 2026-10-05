#pragma once

#include "godot_cpp/classes/node.hpp"

using namespace godot;

class Component : public Node {
    GDCLASS(Component, Node)
    
    private:
        bool active = true;
    public:
        bool is_active() { return active; }
};
