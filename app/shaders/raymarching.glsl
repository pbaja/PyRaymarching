
// Returns nearest distance to and object id from given point
vec2 map(in vec3 pos)
{
    vec2 d1 = vec2(sdPlane(pos), 1);
    vec2 d2 = vec2(sdSphere(pos - vec3(0.0, 2.0, 0.0)), 2);
    vec2 d3 = vec2(sdSphere(pos - vec3(2.0, 1.2, 2.0)), 3);
    return sdUnion(sdUnion(d1, d2), d3);
}

// Returns distance to and object id that has been intersected by ray
vec2 intersect(in vec3 ro, in vec3 rd)
{
    float depth = NEAR;
    for(int i=0;i<MAX_STEPS;i++)
    {
        // Travel through map
        vec2 dist = map(ro + rd * depth);
        if(dist.x < EPSILON)
        {
            // Hit something
            return vec2(depth, dist.y);
        }
        
        // Move further
        depth += dist.x;
    }

    // Nothing found
    return vec2(0);
}

vec3 estimateNormal(vec3 p) 
{
    return normalize(vec3(
        map(vec3(p.x + EPSILON, p.y, p.z)).x - map(vec3(p.x - EPSILON, p.y, p.z)).x,
        map(vec3(p.x, p.y + EPSILON, p.z)).x - map(vec3(p.x, p.y - EPSILON, p.z)).x,
        map(vec3(p.x, p.y, p.z  + EPSILON)).x - map(vec3(p.x, p.y, p.z - EPSILON)).x
    ));
}

void raymarch(in vec3 ro, in vec3 rd, out vec3 color)
{
    // Light dir
    vec3 ld = normalize(vec3(-0.5, 0.4, -0.6));

    vec2 result = intersect(ro, rd);
    if(result.y > 0.0)
    {
        // Calculate intersection point, normal vector and reflection vector
        vec3 pos = ro + rd * result.x;
        vec3 nor = estimateNormal(pos);
        vec3 ref = reflect(rd, nor);

        // Light
        vec3 light = vec3(1);
        
        float dif = clamp( dot( nor, ld ), 0.0, 1.0 );
        light += 2.20*dif*vec3(1.30,1.00,0.70);

        vec3  hal = normalize( ld-rd );
        float spe = pow( clamp( dot( nor, hal ), 0.0, 1.0 ),16.0);
        spe *= dif;
        spe *= 0.04+0.96*pow(clamp(1.0-dot(hal,ld),0.0,1.0),5.0);
        light += 5.00*spe*vec3(1.30,1.00,0.70);

        //float diffuse = max(dot(norm, -ld), 0);
        //color *= diffuse;

        //vec3 ldr = normalize(reflect(-ld, norm));
        //float specular = max(dot(ldr, rd), 0.0);
        //specular = pow(specular, 3);
        //color += vec3(0.2) * specular;

        //float scatter = pow(1.0-dot(rd, -norm), 2);
        
        // Calculate color
        if(result.y == 1)
        {
            color = texture2D(Texture, pos.xz).rgb;
        }
        else if(result.y == 2) 
        {
            color = vec3(0.8, 1.0, 0.2);
        }
        else if(result.y == 3) 
        {
            color = vec3(0.0, 0.5, 1.0);
        }
        color *= light;
    }
    else
    {
        //color = texture2D(Texture, vert_uv).rgb;
        color = textureCube(Skybox, -rd).rgb;
    }
}