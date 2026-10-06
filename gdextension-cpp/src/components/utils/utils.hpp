#pragma once

#include <godot_cpp/classes/project_settings.hpp>
#include <godot_cpp/classes/script.hpp>

using namespace godot;

class UtilsGD {
private:
	UtilsGD() = default;
	~UtilsGD() = default;

public:
	static bool is_of_type(const Ref<Script> &child, const Ref<Script> &parent, const Ref<Script> &early_stop = nullptr) {
		Ref<Script> current = child;
		while (current.ptr() && current != early_stop && current != parent) {
			current = current->get_base_script();
			if (current == parent) {
				return true;
			}
		}
		return false;
	}
};
