//this is an example of custom shape
//it takes p and s as parameters (position and scale)
//and returns result (float)
//of course this is mandelbulb
float CustomShape(vec3 p, vec4 s)
{
    float result = 0;
    float thres = length(p) - 1.2;
    if (thres > 0.2) {
        return thres;
    }
    
    // Zn <- Zn^8 + c
    // Zn' <- 8*Zn^7 + 1    
    const float power = 8.0;
    vec3 z = p;
    vec3 c = p;
        
    float dr = 1.0;
    float r = 0.0;
    for (int i = 0; i < 100; i++) {   
        // to polar
        r = length(z);
        if (r > 2.0) {
        break;
        }        
        float theta = acos(z.z/r);
        float phi = atan(z.y, z.x);
        
        // derivate
        dr = pow(r, power - 1.0) * power * dr + 1.0;
        
        // scale and rotate
        float zr = pow(r, power);
        theta *= power;
        phi *= power;
        
        // to cartesian
        z = zr * vec3(sin(theta)*cos(phi), sin(phi)*sin(theta), cos(theta));        
        z += c;
    }
    
    result = 0.5 * log(r) * r / dr;

return result;
}
