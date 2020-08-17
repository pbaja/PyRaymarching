#version 330

// Inputs
in vec2 in_vert;
in vec2 in_uv;

// Outputs
out vec2 vert_uv;

void main() 
{
    gl_Position = vec4(in_vert, 0.0, 1.0);
    vert_uv = in_uv;
}