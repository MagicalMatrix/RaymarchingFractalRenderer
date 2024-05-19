
float SingleShape(vec3 p, vec4 s, int type)
{

//vec4 result = vec4(0, 0, 0, 0);
float result = 0;

if (type == 0)
{
result = length(p);
} else if (type == 1)
{
result = SphereShape(p, s);
} else if (type == 2)
{
result = CubeShape(p, s);
} else if (type == 3)
{
result = CylinderShape(p, s);
} else if (type == 4)
{
result = OctahedronShape(p, s);
} else if (type == 5)
{
result = ConeShape(p, s);
} else if (type == 6)
{
	result = PlaneShape(p, s);
}
else //custom
{
	result = CustomShape(p, s);
}

return result;
}