#ifndef TERRAIN_CHUNK_H
#define TERRAIN_CHUNK_H

#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/classes/fast_noise_lite.hpp>
#include <godot_cpp/classes/surface_tool.hpp>
#include <godot_cpp/classes/material.hpp>

namespace godot {

class TerrainChunk : public MeshInstance3D {
    GDCLASS(TerrainChunk, MeshInstance3D)

private:
    // Inspector Variables
    float mountain_threshold = 0.15f;
    float lake_threshold = -0.2f;
    float mountain_height_step = 5.0f;
    float lake_depth_step = -2.5f;
    float plains_variation = 0.2f;
    int plateau_levels = 4;
    Ref<Material> material;

protected:
    static void _bind_methods();

public:
    TerrainChunk();
    ~TerrainChunk();

    // Generation Functions
    void generate_chunk(Vector2i p_c_pos, int p_size, Ref<FastNoiseLite> p_b_noise, Ref<FastNoiseLite> p_m_noise, Ref<FastNoiseLite> p_cell_noise);
    float _calculate_plateau_stack(float gx, float gy, float b_val, float height_multi, Ref<FastNoiseLite> cell_noise);
    float _get_mountain_height(float gx, float gy, float b_val, Ref<FastNoiseLite> cell_noise);
    float _get_plains_height(float gx, float gy, Ref<FastNoiseLite> cell_noise);

    // Getters/Setters for Inspector
    void set_mountain_threshold(float p_val) { mountain_threshold = p_val; }
    float get_mountain_threshold() const { return mountain_threshold; }
    void set_lake_threshold(float p_val) { lake_threshold = p_val; }
    float get_lake_threshold() const { return lake_threshold; }
    void set_mountain_height_step(float p_val) { mountain_height_step = p_val; }
    float get_mountain_height_step() const { return mountain_height_step; }
    void set_lake_depth_step(float p_val) { lake_depth_step = p_val; }
    float get_lake_depth_step() const { return lake_depth_step; }
    void set_plains_variation(float p_val) { plains_variation = p_val; }
    float get_plains_variation() const { return plains_variation; }
    void set_plateau_levels(int p_val) { plateau_levels = p_val; }
    int get_plateau_levels() const { return plateau_levels; }
    void set_material(Ref<Material> p_mat) { material = p_mat; }
    Ref<Material> get_material() const { return material; }
};

}

#endif