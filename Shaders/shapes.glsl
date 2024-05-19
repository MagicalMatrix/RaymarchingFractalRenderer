
//SimplePrymitives (only range)
float SphereShape(vec3 p, vec4 s)
{
p /= s.xyz;
float result = 0;
result = length(p) - 1;

return result - s.w;
}

float CubeShape(vec3 p, vec4 s)
{
p = abs(p);

p /= s.xyz;

float result = length(vec3(max(0, p.x - 1), max(0, p.y - 1), max(0, p.z - 1)));
if (p.x < 1 && p.y < 1 && p.z < 1)
{
result = max(p.x - 1, max(p.y - 1, p.z - 1));
}

return result - s.w;
}

float OctahedronShape(vec3 p, vec4 s)
{
p = abs(p);

p /= s.xyz;

float sum = p.x + p.y + p.z;

float result = length(p - vec3(p / sum));
return result * sign(sum - 1) - s.w;
}

float CylinderShape(vec3 p, vec4 s)
{
p = abs(p);
p /= s.xyz;

float result = length(vec2(max(0, length(p.xz) - 1), max(0, p.y - 1)));
if (p.y < 1 && length(p.xz) < 1)
{
result = max(p.y - 1, length(p.xz) - 1);
}

return result - s.w;
}

float ConeShape(vec3 p, vec4 s)
{
p = abs(p);
p /= s.xyz;

vec2 rootP = vec2(length(p.xz), p.y);
float sum = length(p.xz) + p.y;

float result = length(rootP - vec2(rootP / sum));

return result * sign(sum - 1) - s.w;
}

//propably delete since I don't remember what it does exacly
float PlaneShape(vec3 p, vec4 s)
{
	p /= s.xyz;
	float result = 0;

	result = -p.x * p.x - p.z * p.z;

	result = p.y - result;

	result = pow(abs(result), 1. / 2.) * sign(result);
	result = 1 - result;
	return result - s.w;
}