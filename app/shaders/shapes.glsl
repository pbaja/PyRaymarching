
float sdSphere(in vec3 pos)
{
    return length(pos) - 1.0;
}

float sdPlane(in vec3 pos)
{
    return pos.y;
}

vec4 sdUnion(vec4 a, vec4 b)
{
    return (a.a < b.a) ? a : b;
}