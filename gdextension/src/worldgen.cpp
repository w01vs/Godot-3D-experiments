#include "worldgen.h"
#include <godot_cpp/variant/utility_functions.hpp>
#include <algorithm>
#include <vector>
#include <godot_cpp/classes/standard_material3d.hpp>

using namespace godot;

void TerrainChunk::_bind_methods() {
    // Bind Generation Method
    ClassDB::bind_method(D_METHOD("generate_chunk", "c_pos", "size", "b_noise", "m_noise", "cell_noise"), &TerrainChunk::generate_chunk);

    // Bind Properties for Inspector
    ClassDB::bind_method(D_METHOD("get_mountain_threshold"), &TerrainChunk::get_mountain_threshold);
    ClassDB::bind_method(D_METHOD("set_mountain_threshold", "p_val"), &TerrainChunk::set_mountain_threshold);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "mountain_threshold"), "set_mountain_threshold", "get_mountain_threshold");

    ClassDB::bind_method(D_METHOD("get_mountain_height_step"), &TerrainChunk::get_mountain_height_step);
    ClassDB::bind_method(D_METHOD("set_mountain_height_step", "p_val"), &TerrainChunk::set_mountain_height_step);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "mountain_height_step"), "set_mountain_height_step", "get_mountain_height_step");

    ClassDB::bind_method(D_METHOD("get_lake_threshold"), &TerrainChunk::get_lake_threshold);
    ClassDB::bind_method(D_METHOD("set_lake_threshold", "p_val"), &TerrainChunk::set_lake_threshold);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "lake_threshold"), "set_lake_threshold", "get_lake_threshold");

    ClassDB::bind_method(D_METHOD("get_plains_variation"), &TerrainChunk::get_plains_variation);
    ClassDB::bind_method(D_METHOD("set_plains_variation", "p_val"), &TerrainChunk::set_plains_variation);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "plains_variation"), "set_plains_variation", "get_plains_variation");

    ClassDB::bind_method(D_METHOD("get_lake_depth_step"), &TerrainChunk::get_lake_depth_step);
    ClassDB::bind_method(D_METHOD("set_lake_depth_step", "p_val"), &TerrainChunk::set_lake_depth_step);
    ADD_PROPERTY(PropertyInfo(Variant::FLOAT, "lake_depth_step"), "set_lake_depth_step", "get_lake_depth_step");

    ClassDB::bind_method(D_METHOD("get_plateau_levels"), &TerrainChunk::get_plateau_levels);
    ClassDB::bind_method(D_METHOD("set_plateau_levels", "p_val"), &TerrainChunk::set_plateau_levels);
    ADD_PROPERTY(PropertyInfo(Variant::INT, "plateau_levels"), "set_plateau_levels", "get_plateau_levels");

    ClassDB::bind_method(D_METHOD("set_material", "p_mat"), &TerrainChunk::set_material);
    ClassDB::bind_method(D_METHOD("get_material"), &TerrainChunk::get_material);
    ClassDB::bind_method(D_METHOD("get_material"), &TerrainChunk::get_material);
}

TerrainChunk::TerrainChunk() {}
TerrainChunk::~TerrainChunk() {}

float TerrainChunk::_get_mountain_height(float gx, float gy, float b_val, Ref<FastNoiseLite> cell_noise) {
    // 1. Get the raw cellular shape
    float v = cell_noise->get_noise_2d(gx, gy);
    float norm_v = (v + 1.0f) * 0.5f;

    // 2. THE SECRET: Tapering
    // We calculate how "deep" into the mountain biome we are.
    // As b_val increases toward 1.0, we allow more height.
    float biome_intensity = (b_val - mountain_threshold) / (1.0f - mountain_threshold);
    
    // 3. Combine cellular steps with biome intensity
    // This forces the "outer" cells to stay low and the "inner" cells to go high
    float raw_steps = std::floor(norm_v * (float)plateau_levels);
    float tapered_steps = std::min(raw_steps, std::floor(biome_intensity * (float)plateau_levels + 1.0f));

    float variation = (cell_noise->get_noise_2d(gx * 10, gy * 10) * 0.2f);
    return tapered_steps * (mountain_height_step + variation);
}

// For the subtle "Blender" layers on the floor
float TerrainChunk::_get_plains_height(float gx, float gy, Ref<FastNoiseLite> cell_noise) {
    float v = cell_noise->get_noise_2d(gx, gy);
    float norm_v = (v + 1.0f) * 0.5f;
    
    // 2 very small, wide steps (0.5 height each)
    float steps = std::floor(norm_v * 2.0f); 
    return steps * 0.5f; 
}

float TerrainChunk::_calculate_plateau_stack(float gx, float gy, float b_val, float height_multi, Ref<FastNoiseLite> cell_noise) {
    if (cell_noise.is_null()) return 0.0f;

    // 1. Get the raw noise (0.0 to 1.0)
    float v = cell_noise->get_noise_2d(gx, gy);
    float norm_v = (v + 1.0f) * 0.5f;
    float scaled_v = norm_v * (float)plateau_levels;

    // 2. Separate the "Integer" (The Floor) and the "Fraction" (The Slope)
    float floor_val = std::floor(scaled_v);
    float fraction = scaled_v - floor_val;

    // 3. Create a Steep Slope
    // We only want the fraction to affect height when it's near the edge.
    // Adjust 'steepness' (0.5 = 45 deg, 0.9 = very steep, 0.1 = gentle slope)
    float steepness = 0.85f; 
    float slope = 0.0f;
    
    if (fraction > steepness) {
        slope = (fraction - steepness) / (1.0f - steepness);
        // Smoothstep makes the top and bottom of the cliff feel more natural
        slope = slope * slope * (3.0f - 2.0f * slope);
    }

    // 4. Final Height
    return (floor_val + slope) * height_multi;
}

void TerrainChunk::generate_chunk(Vector2i p_c_pos, int p_size, Ref<FastNoiseLite> p_b_noise, Ref<FastNoiseLite> p_m_noise, Ref<FastNoiseLite> p_cell_noise) {
    Ref<SurfaceTool> st;
    st.instantiate();
    st->begin(Mesh::PRIMITIVE_TRIANGLES);

    int res = p_size + 1;
    Vector2 world_offset = Vector2(p_c_pos.x * p_size, p_c_pos.y * p_size);
    std::vector<float> heights(res * res);

    // 1. HEIGHT GENERATION (The "Logic" Layer)
    for (int x = 0; x < res; x++) {
    for (int y = 0; y < res; y++) {
        float gx = world_offset.x + x;
        float gy = world_offset.y + y;
        float b_val = p_b_noise->get_noise_2d(gx, gy);
        
        float h = 0.0f;

        if (b_val > mountain_threshold) {
            // MOUNTAIN BIOME: Big jumps, high plateaus
            h = _get_mountain_height(gx, gy, b_val, p_cell_noise);
        } 
        else if (b_val < lake_threshold) {
            // LAKE BIOME: Steps downward
            h = -_get_mountain_height(gx, gy, b_val, p_cell_noise) * 0.5f;
        }
        else {
            // PLAINS BIOME: The "Subtle" look you wanted
            h = _get_plains_height(gx, gy, p_cell_noise);
        }

        heights[x * res + y] = h;
    }
}
    // 2. MESH BUILDING (The "Visual" Layer)
    Color color_flat = Color(1.0, 1.0, 1.0); // White
    Color color_slope = Color(0.2, 0.5, 0.1); // Green

    for (int x = 0; x < p_size; x++) {
        for (int y = 0; y < p_size; y++) {
            // Get the 4 corners of the quad
            float h1 = heights[x * res + y];           // TL
            float h2 = heights[x * res + (y + 1)];     // BL
            float h3 = heights[(x + 1) * res + y];     // TR
            float h4 = heights[(x + 1) * res + (y + 1)]; // BR

            Vector3 v1(x, h1, y);
            Vector3 v2(x, h2, y + 1);
            Vector3 v3(x + 1, h3, y);
            Vector3 v4(x + 1, h4, y + 1);

            // Color Helper: Detects steepness
            auto get_tri_color = [&](float a, float b, float c) {
                float diff = std::max({a, b, c}) - std::min({a, b, c});
                // We only color if the jump is significant (ignoring the tiny plains steps)
                return (diff > 0.6f) ? color_slope : color_flat;
            };
            
            // Different coloring
            // auto get_tri_color = [&](float a, float b, float c, float b_val) {
            //     float diff = std::max({a, b, c}) - std::min({a, b, c});
            //     // Only color green if it's steep AND we are in the mountain zone
            //     if (diff > 0.4f && b_val > mountain_threshold) {
            //         return color_slope; 
            //     }
            //     return color_flat;
            // };

            // QUAD ALIGNMENT: Choose the diagonal that creates the flattest face
            if (std::abs(h1 - h4) < std::abs(h2 - h3)) {
                // Triangle 1 (v1-v3-v4)
                st->set_color(get_tri_color(h1, h3, h4));
                st->add_vertex(v1); st->add_vertex(v3); st->add_vertex(v4);
                // Triangle 2 (v1-v4-v2)
                st->set_color(get_tri_color(h1, h4, h2));
                st->add_vertex(v1); st->add_vertex(v4); st->add_vertex(v2);
            } else {
                // Triangle 1 (v1-v3-v2)
                st->set_color(get_tri_color(h1, h3, h2));
                st->add_vertex(v1); st->add_vertex(v3); st->add_vertex(v2);
                // Triangle 2 (v2-v3-v4)
                st->set_color(get_tri_color(h2, h3, h4));
                st->add_vertex(v2); st->add_vertex(v3); st->add_vertex(v4);
            }
        }
    }

    // 3. FINALIZE & MATERIAL
    st->generate_normals();
    
    Ref<Mesh> mesh = st->commit();
    set_mesh(mesh);
    if(material.is_valid()) {
        set_surface_override_material(0, material);
    }
}