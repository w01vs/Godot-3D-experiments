/* godot-cpp integration testing project.
 *
 * This is free and unencumbered software released into the public domain.
 */

#pragma once

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void initialize_module(ModuleInitializationLevel p_level);
void uninitialize_module(ModuleInitializationLevel p_level);
