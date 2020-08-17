#version 330

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

    // Light
    vec3 lightDir = normalize(vec3(-0.5, -0.2, 0.1));

    // Intersect scene
    vec3 color = vec3(0.0);
    float dist = intersect(ro, rd, color);
    if(dist > 0.0)
    {
        // Calculate intersection point and normal vector
        vec3 pos = ro + rd * dist;
        vec3 norm = estimateNormal(pos);

        // Light
        float lambert = max(dot(norm, -lightDir), 0);

        // Calculate color
        color *= lambert;
    }
    else
    {
        //color = texture2D(Texture, vert_uv).rgb;
        color = textureCube(Skybox, -rd).rgb;
    }

    // Assign result
    out_color = vec4(color, 1);
}