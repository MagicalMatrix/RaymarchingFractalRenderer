float sdCross( vec3 p, vec3 b) {
  vec3 d = abs(p) - b;
  return min(min(max(d.x, d.y),max(d.x, d.z)),max(d.y, d.z));
}

float repCross( vec3 p, vec3 c, vec3 b )
{
  vec3 q = mod(p,c)-0.5*c;
  return sdCross( q, b );
}

float CustomShape(vec3 p, vec4 s)
{
	float v = CubeShape(p, s);
	//float v = CylinderShape(p, s);

	for(int i = 0; i < 5; i++) {        
      v = max( v, -repCross( p + vec3(s/1.0), vec3(s*2.0), vec3(s/3.0) ) );
      s /= 3.0;  
    }

	return v;
}