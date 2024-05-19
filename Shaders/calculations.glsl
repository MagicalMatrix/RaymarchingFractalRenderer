
float Dot3 (vec3 a, vec3 b)
{
return a.x * b.x + a.y * b.y + a.z * b.z;
}

vec3 ToDirection (vec3 v)
{
float vMax = max(max(abs(v.x), abs(v.y)), abs(v.z));
//v = v / vMax;

return v / abs(vMax);
}

//Immidently add, it is not a direction, it is an already calculated distance in vec3
vec3 DistanceToVector (float dist, vec3 dir)
{
//vec3 power = vec3(v.x * v.x);
float root = dist * dist / (dir.x * dir.x + dir.y * dir.y + dir.z * dir.z);

return dir * root;
}

//v is regular vector, rot is in deegres
vec3 Rotate3D(vec3 v, vec3 rot) //using deegres
{
vec3 rad = 0.0174532924 * rot;
vec3 Cos = cos(rad);
vec3 Sin = sin(rad);

//x axis
v = vec3(v.x, Cos.x * v.y + Sin.x * v.z, -Sin.x * v.y + Cos.x * v.z);
//y axis
v = vec3(Cos.y * v.x - Sin.y * v.z, v.y, Sin.y * v.x + Cos.y * v.z);
//z axis
v = vec3(Cos.z * v.x + Sin.z * v.y, -Sin.z * v.x + Cos.z * v.y, v.z);

return v;
}

//This can be used as Rotate3D with a 1, 1, 1 Starting Vector (as a property)
vec3 DegreesToVector(vec3 rot)
{
vec3 rad = 0.0174532925 * rot;
vec3 Cos = cos(rad);
vec3 Sin = sin(rad);

vec3 v = vec3(1, 1, 1);
//x axis
v = vec3(v.x, Cos.x * v.y + Sin.x * v.z, -Sin.x * v.y + Cos.x * v.z);
//y axis
v = vec3(Cos.y * v.x - Sin.y * v.z, v.y, Sin.y * v.x + Cos.y * v.z);
//z axis
v = vec3(Cos.z * v.x + Sin.z * v.y, -Sin.z * v.x + Cos.z * v.y, v.z);

return v;
}

vec3 VectorToDegrees(vec3 v)
{
float pi = 3.14;
//vec3 degrees = vec3(
//atan2(v.y, v.z) * 180 / pi,
//atan2(v.x, v.z) * 180 / pi,
//atan2(v.x, v.y) * 180 / pi);

vec3 degrees = vec3(
atan(v.z, v.y) * 180 / pi,
atan(v.z, v.x) * 180 / pi,
atan(v.y, v.x) * 180 / pi
);

return degrees;
}


//In deegress
vec3 RotationDistance (vec3 Rot1, vec3 Rot2)
{
Rot1 %= 360;
Rot2 %= 360;

vec3 result = Rot1 - Rot2;
result = vec3(abs(result.x), abs(result.y), abs(result.z));
return result;
}

float Distance (vec3 Cord)
{
return sqrt(Cord.x * Cord.x + Cord.y * Cord.y + Cord.z * Cord.z);
}

//result is direction
vec3 LookAt(vec3 Sp, vec3 Rp)
{
vec3 LookDir = Rp - Sp;
LookDir /= max(LookDir.x, max(LookDir.y, LookDir.z));

return LookDir;
}


//NoiseHERE
vec3 hash( vec3 p ){ // replace this by something better
	p = vec3( dot(p,vec3(127.1,311.7, 74.7)),
			  dot(p,vec3(269.5,183.3,246.1)),
			  dot(p,vec3(113.5,271.9,124.6)));
	return -1.0 + 2.0*fract(sin(p)*43758.5453123);
}


float GradientNoise( in vec3 p ){
    vec3 i = floor( p );
    vec3 f = fract( p );
	vec3 u = f*f*(3.0-2.0*f);
    return mix( mix( mix( dot( hash( i + vec3(0.0,0.0,0.0) ), f - vec3(0.0,0.0,0.0) ), 
                          dot( hash( i + vec3(1.0,0.0,0.0) ), f - vec3(1.0,0.0,0.0) ), u.x),
                     mix( dot( hash( i + vec3(0.0,1.0,0.0) ), f - vec3(0.0,1.0,0.0) ), 
                          dot( hash( i + vec3(1.0,1.0,0.0) ), f - vec3(1.0,1.0,0.0) ), u.x), u.y),
                mix( mix( dot( hash( i + vec3(0.0,0.0,1.0) ), f - vec3(0.0,0.0,1.0) ), 
                          dot( hash( i + vec3(1.0,0.0,1.0) ), f - vec3(1.0,0.0,1.0) ), u.x),
                     mix( dot( hash( i + vec3(0.0,1.0,1.0) ), f - vec3(0.0,1.0,1.0) ), 
                          dot( hash( i + vec3(1.0,1.0,1.0) ), f - vec3(1.0,1.0,1.0) ), u.x), u.y), u.z );
}


float PseudoRandom (float Seed)
{
//Classic Random value
float result = fract(sin(dot(vec2(Seed, 12.9898), vec2(78.233,45.5432))) * 43758.5453);
return result;
}


vec2 PseudoRandom2(vec2 p) {
return fract(sin(vec2(dot(p,vec2(127.1,311.7)),dot(p,vec2(269.5,183.3))))*43758.5453);
}


float AlphaBlend (float bgA, float adA)
{
float result;
result = 1 - (1 - adA) * (1 - bgA);
return result;
}

vec4 ColorBlend(vec4 bgCol, vec4 adCol)
{
vec4 result = vec4(1, 1, 1, 1);
result.a = 1 - (1 - adCol.a) * (1 - bgCol.a);
result.rgb = adCol.rgb * adCol.a / result.a + bgCol.rgb * bgCol.a * (1 - adCol.a) / result.a;

return result;
}

vec4 ColorToHue (vec4 col)
{
vec4 result = vec4(0, 0, 0, col.a);
//value //brightness
result.y = min(col.x, min(col.y, col.z));
//saturation //intensity
result.z = max(col.x, max(col.y, col.z)) - result.y;

if (col.x - (result.y + result.z) == 0)
{
	result.x = 4;

	if (col.z > col.y)
	{
	result.x += (col.z - result.y) / result.z + 1;
	} else
	{
	result.x += (1 - (col.y - result.y) / result.z);
	}

} else if (col.y - (result.y + result.z) == 0)
{
	result.x = 2;

	if (col.r > col.z)
	{
	result.x += (col.r - result.y) / result.z + 1;
	} else
	{
	result.x += (1 - (col.z - result.y) / result.z);
	}
} else
{
	result.x = 0;

	if (col.y > col.x)
	{
	result.x += (col.y - result.y) / result.z + 1;
	} else
	{
	result.x += (1 - (col.x - result.y) / result.z);
	}
}

result.x /= 6;
return result;

}

vec4 HueToColor (vec4 hue)
{
hue.x = mod(abs(hue.x), 1.0);
hue.x *= 6;

vec4 result = vec4(0, 0, 0, hue.w);

if (hue.x >= 4)
{
	result.x = hue.z;

	if ((hue.x - 4) <= 1)
	{
	result.y = (1 - (hue.x - 4)) * hue.z;
	} else
	{
	result.z = (hue.x - 5) * hue.z;
	}
} else if (hue.x <= 2)
{
	result.z = hue.z;

	if (hue.x <= 1)
	{
	result.x = (1 - hue.x) * hue.z;
	} else
	{
	result.y = (hue.x - 1) * hue.z;
	}
} else
{
	result.y = hue.z;

	if ((hue.x - 2) <= 1)
	{
	result.z = (1 - (hue.x - 2)) * hue.z;
	} else
	{
	result.x = (hue.x - 3) * hue.z;
	}
}

result.xyz += hue.y;

return result;

}