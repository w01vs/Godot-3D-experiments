#ifndef TERRAIN_CHUNK_H
#define TERRAIN_CHUNK_H

#include <godot_cpp/classes/mesh_instance3d.hpp>
#include <godot_cpp/classes/fast_noise_lite.hpp>
#include <godot_cpp/variant/dictionary.hpp>

using namespace godot;

class TerrainChunk : public MeshInstance3D {
    GDCLASS(TerrainChunk, MeshInstance3D);

private:

    Ref<FastNoiseLite> continentalness_noise;
    Ref<FastNoiseLite> erosion_noise;
    Ref<FastNoiseLite> height_noise;
    Ref<FastNoiseLite> temperature_noise;
    Ref<FastNoiseLite> humidity_noise;
    Ref<FastNoiseLite> terrace_noise;

    Dictionary region_settings;
    Dictionary contineltalness_spline;
    Dictionary erosion_spline;
    Dictionary height_spline;
    Dictionary terrace_settings;
    bool debug_chunk_stats = false;

    float get_height(float world_x, float world_z, Dictionary spline_dict);
    float evaluate_spline(float noise_val, Dictionary spline_dict);
    float get_step_height(float final_height, float world_x, float world_z);

protected:
    static void _bind_methods();

public:

    TerrainChunk();
    ~TerrainChunk();

    void generate_chunk(Vector2i chunk_pos, int chunk_size, Dictionary spline_dict);

    void set_continentalness_noise(Ref<FastNoiseLite> noise) { continentalness_noise = noise; }
    void set_erosion_noise(Ref<FastNoiseLite> noise) { erosion_noise = noise; }
    void set_height_noise(Ref<FastNoiseLite> noise) { height_noise = noise; }
    void set_temperature_noise(Ref<FastNoiseLite> noise) { temperature_noise = noise; }
    void set_humidity_noise(Ref<FastNoiseLite> noise) { humidity_noise = noise; }
    void set_terrace_noise(Ref<FastNoiseLite> noise) { terrace_noise = noise; }

    void set_continentalness_spline(Dictionary spline) { contineltalness_spline = spline; }
    void set_erosion_spline(Dictionary spline) { erosion_spline = spline; }
    void set_height_spline(Dictionary spline) { height_spline = spline; }

    void set_region_settings(Dictionary settings) { region_settings = settings; }
    void set_terrace_settings(Dictionary settings) {
        Array keys = settings.keys();
        for (int i = 0; i < keys.size(); i++) {
            terrace_settings[keys[i]] = settings[keys[i]];
        }
    }
    void set_debug_chunk_stats(bool enabled) { debug_chunk_stats = enabled; }

    Ref<FastNoiseLite> get_continentalness_noise() { return continentalness_noise; }
    Ref<FastNoiseLite> get_erosion_noise() { return erosion_noise; }
    Ref<FastNoiseLite> get_height_noise() { return height_noise; }
    Ref<FastNoiseLite> get_temperature_noise() { return temperature_noise; }
    Ref<FastNoiseLite> get_humidity_noise() { return humidity_noise; }
    Ref<FastNoiseLite> get_terrace_noise() { return terrace_noise; }

    Dictionary get_continentalness_spline() { return contineltalness_spline; }
    Dictionary get_erosion_spline() { return erosion_spline; }
    Dictionary get_height_spline() { return height_spline; }

    Dictionary get_region_settings() { return region_settings; }
    Dictionary get_terrace_settings() { return terrace_settings; }
    bool get_debug_chunk_stats() { return debug_chunk_stats; }

};

#endif // TERRAIN_CHUNK_H