
float sdSphere(in vec3 pos)
{
    return length(pos) - 1.0;
}

float sdPlane(in vec3 pos)
{
    return pos.y;
}

vec2 sdUnion(vec2 a, vec2 b)
{
    return (a.x < b.x) ? a : b;
}