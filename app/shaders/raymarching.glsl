
vec4 map(in vec3 pos)
{
    vec4 d1 = vec4(0, 0, 1, sdSphere(pos - vec3(0.0, 2.0, 0.0)));
    vec4 d2 = vec4(0, 1, 0, sdPlane(pos));
    return sdUnion(d1, d2);
}

float intersect(in vec3 ro, in vec3 rd, out vec3 color)
{
    float depth = NEAR;
    for(int i=0;i<MAX_STEPS;i++)
    {
        // Intersect scene
        vec4 dist = map(ro + rd * depth);
        if(dist.a < EPSILON)
        {
            color = dist.rgb;//vec3(0, depth * 0.1, 0);
            return depth;
        }
        
        // Move further
        depth += dist.a;
    }

    color = vec3(0,0,0);
    return 0.0;
}

vec3 estimateNormal(vec3 p) 
{
    return normalize(vec3(
        map(vec3(p.x + EPSILON, p.y, p.z)).a - map(vec3(p.x - EPSILON, p.y, p.z)).a,
        map(vec3(p.x, p.y + EPSILON, p.z)).a - map(vec3(p.x, p.y - EPSILON, p.z)).a,
        map(vec3(p.x, p.y, p.z  + EPSILON)).a - map(vec3(p.x, p.y, p.z - EPSILON)).a
    ));
}