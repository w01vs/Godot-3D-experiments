#include "terrainchunk.h"

#include <godot_cpp/classes/surface_tool.hpp>
#include <godot_cpp/classes/array_mesh.hpp>
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

TerrainChunk::TerrainChunk() {
    terrace_settings["base_step_height"] = 2.0f;
    terrace_settings["max_step_multiple"] = 6;
    terrace_settings["mountain_start_height"] = 48.0f;
    terrace_settings["mountain_full_height"] = 160.0f;
    terrace_settings["control_noise_scale"] = 0.035f;
}

TerrainChunk::~TerrainChunk() {
}

void TerrainChunk::_bind_methods() {

    ClassDB::bind_method(D_METHOD("generate_chunk", "chunk_pos", "chunk_size", "spline_dict"), &TerrainChunk::generate_chunk);

    ClassDB::bind_method(D_METHOD("set_continentalness_noise", "noise"), &TerrainChunk::set_continentalness_noise);
    ClassDB::bind_method(D_METHOD("get_continentalness_noise"), &TerrainChunk::get_continentalness_noise);
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "continentalness_noise", PROPERTY_HINT_RESOURCE_TYPE, "FastNoiseLite"), "set_continentalness_noise", "get_continentalness_noise");

    ClassDB::bind_method(D_METHOD("set_erosion_noise", "noise"), &TerrainChunk::set_erosion_noise);
    ClassDB::bind_method(D_METHOD("get_erosion_noise"), &TerrainChunk::get_erosion_noise);
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "erosion_noise", PROPERTY_HINT_RESOURCE_TYPE, "FastNoiseLite"), "set_erosion_noise", "get_erosion_noise");

    ClassDB::bind_method(D_METHOD("set_height_noise", "noise"), &TerrainChunk::set_height_noise);
    ClassDB::bind_method(D_METHOD("get_height_noise"), &TerrainChunk::get_height_noise);
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "height_noise", PROPERTY_HINT_RESOURCE_TYPE, "FastNoiseLite"), "set_height_noise", "get_height_noise");

    ClassDB::bind_method(D_METHOD("set_temperature_noise", "noise"), &TerrainChunk::set_temperature_noise);
    ClassDB::bind_method(D_METHOD("get_temperature_noise"), &TerrainChunk::get_temperature_noise);
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "temperature_noise", PROPERTY_HINT_RESOURCE_TYPE, "FastNoiseLite"), "set_temperature_noise", "get_temperature_noise");

    ClassDB::bind_method(D_METHOD("set_humidity_noise", "noise"), &TerrainChunk::set_humidity_noise);
    ClassDB::bind_method(D_METHOD("get_humidity_noise"), &TerrainChunk::get_humidity_noise);
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "humidity_noise", PROPERTY_HINT_RESOURCE_TYPE, "FastNoiseLite"), "set_humidity_noise", "get_humidity_noise");

    ClassDB::bind_method(D_METHOD("set_region_settings", "settings"), &TerrainChunk::set_region_settings);
    ClassDB::bind_method(D_METHOD("get_region_settings"), &TerrainChunk::get_region_settings);  
    ADD_PROPERTY(PropertyInfo(Variant::DICTIONARY, "region_settings"), "set_region_settings", "get_region_settings");

    ClassDB::bind_method(D_METHOD("set_continentalness_spline", "spline"), &TerrainChunk::set_continentalness_spline);
    ClassDB::bind_method(D_METHOD("get_continentalness_spline"), &TerrainChunk::get_continentalness_spline);
    ADD_PROPERTY(PropertyInfo(Variant::DICTIONARY, "continentalness_spline"), "set_continentalness_spline", "get_continentalness_spline");

    ClassDB::bind_method(D_METHOD("set_erosion_spline", "spline"), &TerrainChunk::set_erosion_spline);
    ClassDB::bind_method(D_METHOD("get_erosion_spline"), &TerrainChunk::get_erosion_spline);
    ADD_PROPERTY(PropertyInfo(Variant::DICTIONARY, "erosion_spline"), "set_erosion_spline", "get_erosion_spline");

    ClassDB::bind_method(D_METHOD("set_height_spline", "spline"), &TerrainChunk::set_height_spline);
    ClassDB::bind_method(D_METHOD("get_height_spline"), &TerrainChunk::get_height_spline);
    ADD_PROPERTY(PropertyInfo(Variant::DICTIONARY, "height_spline"), "set_height_spline", "get_height_spline");

    ClassDB::bind_method(D_METHOD("set_terrace_settings", "settings"), &TerrainChunk::set_terrace_settings);
    ClassDB::bind_method(D_METHOD("get_terrace_settings"), &TerrainChunk::get_terrace_settings);
    ADD_PROPERTY(PropertyInfo(Variant::DICTIONARY, "terrace_settings"), "set_terrace_settings", "get_terrace_settings");

    ClassDB::bind_method(D_METHOD("set_debug_chunk_stats", "enabled"), &TerrainChunk::set_debug_chunk_stats);
    ClassDB::bind_method(D_METHOD("get_debug_chunk_stats"), &TerrainChunk::get_debug_chunk_stats);
    ADD_PROPERTY(PropertyInfo(Variant::BOOL, "debug_chunk_stats"), "set_debug_chunk_stats", "get_debug_chunk_stats");

    ClassDB::bind_method(D_METHOD("set_terrace_noise", "noise"), &TerrainChunk::set_terrace_noise);
    ClassDB::bind_method(D_METHOD("get_terrace_noise"), &TerrainChunk::get_terrace_noise);
    ADD_PROPERTY(PropertyInfo(Variant::OBJECT, "terrace_noise", PROPERTY_HINT_RESOURCE_TYPE, "FastNoiseLite"), "set_terrace_noise", "get_terrace_noise");
}

float TerrainChunk::evaluate_spline(float noise_val, Dictionary spline_dict) {
    if (spline_dict.is_empty()) return 0.0f;

    Array keys = spline_dict.keys();
    keys.sort(); // Crucial for interpolation

    // Clamp if out of bounds
    if (noise_val <= (float)keys[0]) return spline_dict[keys[0]];
    if (noise_val >= (float)keys[keys.size() - 1]) return spline_dict[keys[keys.size() - 1]];

    // Find the segment to interpolate
    for (int i = 0; i < keys.size() - 1; i++) {
        float x0 = keys[i];
        float x1 = keys[i + 1];

        if (noise_val >= x0 && noise_val <= x1) {
            float y0 = spline_dict[x0];
            float y1 = spline_dict[x1];
            
            // Linear interpolation (t = (val - start) / range)
            float t = (noise_val - x0) / (x1 - x0);
            return y0 + t * (y1 - y0);
        }
    }
    return 0.0f;
}

float TerrainChunk::get_height(float world_x, float world_z, Dictionary master_splines) {
    // 1. Sample Raw Noises (-1.0 to 1.0) [cite: 1, 2]
    float raw_con = continentalness_noise->get_noise_2d(world_x, world_z);
    float raw_ero = erosion_noise->get_noise_2d(world_x, world_z);
    float raw_h   = height_noise->get_noise_2d(world_x, world_z);
    
    float temp    = temperature_noise->get_noise_2d(world_x, world_z);
    float humid   = humidity_noise->get_noise_2d(world_x, world_z);

    // 2. Extract Data and Evaluate Splines
    // Each entry now has a "values" dict and a "weight" float
    Dictionary con_data = master_splines["continentalness"];
    float con_val = evaluate_spline(raw_con, con_data["values"]) * (float)con_data["weight"];

    Dictionary ero_data = master_splines["erosion"];
    float ero_val = evaluate_spline(raw_ero, ero_data["values"]) * (float)ero_data["weight"];

    Dictionary h_data = master_splines["height"];
    float h_val = evaluate_spline(raw_h, h_data["values"]) * (float)h_data["weight"];

    // 3. Determine Biome Roughness
    float biome_roughness = 1.0f;
    Array b_keys = region_settings.keys();
    for (int i = 0; i < b_keys.size(); i++) {
        Dictionary b = region_settings[b_keys[i]];
        if (temp >= (float)b["temp_min"] && temp <= (float)b["temp_max"] &&
            humid >= (float)b["humid_min"] && humid <= (float)b["humid_max"]) {
            biome_roughness = (float)b["roughness"];
            break;
        }
    }

    // 4. Final Minecraft-style Composition
    // Continentalness + Erosion + (Height Detail * Biome Modifier)
    float final_height = con_val + ero_val + (h_val * biome_roughness);

    float base_step_height = (float)terrace_settings["base_step_height"];
    int max_step_multiple = (int)terrace_settings["max_step_multiple"];
    float mountain_start_height = (float)terrace_settings["mountain_start_height"];
    float mountain_full_height = (float)terrace_settings["mountain_full_height"];
    float control_noise_scale = (float)terrace_settings["control_noise_scale"];

    if (base_step_height <= 0.0f) {
        base_step_height = 2.0f;
    }
    if (max_step_multiple < 1) {
        max_step_multiple = 1;
    }

    float mountain_range = mountain_full_height - mountain_start_height;
    if (mountain_range <= 0.0f) {
        mountain_range = 1.0f;
    }

    float mountain_mask = (final_height - mountain_start_height) / mountain_range;
    if (mountain_mask < 0.0f) {
        mountain_mask = 0.0f;
    } else if (mountain_mask > 1.0f) {
        mountain_mask = 1.0f;
    }

    float terrace_control = terrace_noise->get_noise_2d(world_x * control_noise_scale, world_z * control_noise_scale);
    float normalized_control = (terrace_control + 1.0f) / 2.0f;

    int extra_step_count = (int)floor(normalized_control * (float)(max_step_multiple - 1) * mountain_mask);
    int step_multiple = 1 + extra_step_count;
    float step_height = base_step_height * (float)step_multiple;

    return floor(final_height / step_height) * step_height;
}

void TerrainChunk::generate_chunk(Vector2i chunk_pos, int chunk_size, Dictionary spline_dict) {

    Ref<SurfaceTool> st;
    st.instantiate();
    st->begin(Mesh::PRIMITIVE_TRIANGLES);

    int resolution = chunk_size + 1;

    PackedVector3Array vertices;

    float min_raw_con = 999999.0f;
    float max_raw_con = -999999.0f;
    float min_raw_ero = 999999.0f;
    float max_raw_ero = -999999.0f;
    float min_raw_h = 999999.0f;
    float max_raw_h = -999999.0f;
    float min_con_val = 999999.0f;
    float max_con_val = -999999.0f;
    float min_ero_val = 999999.0f;
    float max_ero_val = -999999.0f;
    float min_h_val = 999999.0f;
    float max_h_val = -999999.0f;
    float min_biome_roughness = 999999.0f;
    float max_biome_roughness = -999999.0f;
    float min_step_height = 999999.0f;
    float max_step_height = -999999.0f;
    float min_height = 999999.0f;
    float max_height = -999999.0f;

    auto update_range = [](float value, float &min_value, float &max_value) {
        if (value < min_value) {
            min_value = value;
        }
        if (value > max_value) {
            max_value = value;
        }
    };

    float maximum_height = 0.0f;
    for (int z = 0; z < resolution; z++) {
        for (int x = 0; x < resolution; x++) {

            float world_x = chunk_pos.x * chunk_size + x;
            float world_z = chunk_pos.y * chunk_size + z;

            if (debug_chunk_stats) {
                float raw_con = continentalness_noise->get_noise_2d(world_x, world_z);
                float raw_ero = erosion_noise->get_noise_2d(world_x, world_z);
                float raw_h = height_noise->get_noise_2d(world_x, world_z);
                float temp = temperature_noise->get_noise_2d(world_x, world_z);
                float humid = humidity_noise->get_noise_2d(world_x, world_z);

                Dictionary con_data = spline_dict["continentalness"];
                Dictionary ero_data = spline_dict["erosion"];
                Dictionary h_data = spline_dict["height"];

                float con_val = evaluate_spline(raw_con, con_data["values"]) * (float)con_data["weight"];
                float ero_val = evaluate_spline(raw_ero, ero_data["values"]) * (float)ero_data["weight"];
                float h_val = evaluate_spline(raw_h, h_data["values"]) * (float)h_data["weight"];

                float biome_roughness = 1.0f;
                Array b_keys = region_settings.keys();
                for (int i = 0; i < b_keys.size(); i++) {
                    Dictionary b = region_settings[b_keys[i]];
                    if (temp >= (float)b["temp_min"] && temp <= (float)b["temp_max"] &&
                        humid >= (float)b["humid_min"] && humid <= (float)b["humid_max"]) {
                        biome_roughness = (float)b["roughness"];
                        break;
                    }
                }

                float debug_final_height = con_val + ero_val + (h_val * biome_roughness);
                float base_step_height = (float)terrace_settings["base_step_height"];
                int max_step_multiple = (int)terrace_settings["max_step_multiple"];
                float mountain_start_height = (float)terrace_settings["mountain_start_height"];
                float mountain_full_height = (float)terrace_settings["mountain_full_height"];
                float control_noise_scale = (float)terrace_settings["control_noise_scale"];

                if (base_step_height <= 0.0f) {
                    base_step_height = 2.0f;
                }
                if (max_step_multiple < 1) {
                    max_step_multiple = 1;
                }

                float mountain_range = mountain_full_height - mountain_start_height;
                if (mountain_range <= 0.0f) {
                    mountain_range = 1.0f;
                }

                float mountain_mask = (debug_final_height - mountain_start_height) / mountain_range;
                if (mountain_mask < 0.0f) {
                    mountain_mask = 0.0f;
                } else if (mountain_mask > 1.0f) {
                    mountain_mask = 1.0f;
                }

                float terrace_control = erosion_noise->get_noise_2d(world_x * control_noise_scale, world_z * control_noise_scale);
                float normalized_control = (terrace_control + 1.0f) / 2.0f;
                int extra_step_count = (int)floor(normalized_control * (float)(max_step_multiple - 1) * mountain_mask);
                int step_multiple = 1 + extra_step_count;
                float debug_step_height = base_step_height * (float)step_multiple;

                update_range(raw_con, min_raw_con, max_raw_con);
                update_range(raw_ero, min_raw_ero, max_raw_ero);
                update_range(raw_h, min_raw_h, max_raw_h);
                update_range(con_val, min_con_val, max_con_val);
                update_range(ero_val, min_ero_val, max_ero_val);
                update_range(h_val, min_h_val, max_h_val);
                update_range(biome_roughness, min_biome_roughness, max_biome_roughness);
                update_range(debug_step_height, min_step_height, max_step_height);
            }

            float height = get_height(world_x, world_z, spline_dict);
            maximum_height = Math::max(height, maximum_height);
            if (debug_chunk_stats) {
                update_range(height, min_height, max_height);
            }

            vertices.push_back(Vector3(x, height, z));
        }
    }

    UtilityFunctions::print("Maximum height: ", maximum_height);

    if (debug_chunk_stats) {
        UtilityFunctions::print(
            "Chunk ", chunk_pos,
            " | raw con= [", min_raw_con, ", ", max_raw_con,
            "] raw ero= [", min_raw_ero, ", ", max_raw_ero,
            "] raw height= [", min_raw_h, ", ", max_raw_h,
            "] | con spline= [", min_con_val, ", ", max_con_val,
            "] ero spline= [", min_ero_val, ", ", max_ero_val,
            "] height spline= [", min_h_val, ", ", max_h_val,
            "] | biome roughness= [", min_biome_roughness, ", ", max_biome_roughness,
            "] step height= [", min_step_height, ", ", max_step_height,
            "] | quantized height= [", min_height, ", ", max_height, "]"
        );
    }

    for (int z = 0; z < chunk_size; z++) {
        for (int x = 0; x < chunk_size; x++) {

            int i = z * resolution + x;

            Vector3 v0 = vertices[i];
            Vector3 v1 = vertices[i + 1];
            Vector3 v2 = vertices[i + resolution];
            Vector3 v3 = vertices[i + resolution + 1];

            st->add_vertex(v0);
            st->add_vertex(v1);
            st->add_vertex(v2);

            st->add_vertex(v1);
            st->add_vertex(v3);
            st->add_vertex(v2);
        }
    }

    st->generate_normals();


    Ref<ArrayMesh> mesh = st->commit();
    set_mesh(mesh);
}