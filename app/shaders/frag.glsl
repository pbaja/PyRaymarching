#version 330
#extension GL_NV_shadow_samplers_cube : enable

// Defines
#define PI 3.141592
#define EPSILON 0.01
#define NEAR 0.01
#define MAX_STEPS 200

// Input/output
in vec2 vert_uv;
out vec4 out_color;

// Params
uniform float Time;
uniform samplerCube Skybox;
uniform sampler2D Texture;

#include shapes.glsl
#include raymarching.glsl

void main() 
{
    // Calculate ray
    vec3 ro = vec3(0.0, 2, -6.0); // Ray origin
    vec3 rd = normalize(vec3(vert_uv - vec2(0.5, 0.5), 1.001)); // Ray direction

    // Render
    vec3 color = vec3(0.0);
    raymarch(ro, rd, color);

    // Assign result
    out_color = vec4(color, 1);
}