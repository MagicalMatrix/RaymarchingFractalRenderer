

//Bare representation of gradient noise
vec4 NoiseTex (vec3 p, vec4 s)
{
//p /= s;

float result = GradientNoise(p / s.xyz);

return vec4(result, result, result, 1);
}


//Based on distance fields
vec4 BrickTexture (vec3 p, vec4 s)
{

p = SquareSpaceLoop(p.xyz, s.xyz);

float result = CubeShape(p, vec4(s.xyz / s.w / 2, 0));

//result = (sin(result) + 1) / 2;

if (result <= 0)
{
//result = 0.5;
//result = 0.5 - abs(result) / min(s.x / s.w / 2, min(s.y / s.w / 2, s.z / s.w / 2)) / 2;
result = 0.5 - abs(result) / abs( CubeShape(vec3(0, 0, 0), vec4(s.xyz / s.w / 2, 0)) ) / 2;
} else
{
//result = 1;
result = 0.5 + result / (length(s.xyz) - length(s.xyz / s.w / 2)) / 2;
}

return vec4(result, result, result, 0);
}


//Noise based
vec4 WoodTex (vec3 p, vec4 s)
{
p = Rotate3D(p, vec3(GradientNoise(p / s.xyz) * 360, GradientNoise(p / s.xyz) * 360, GradientNoise(p / s.xyz) * 360));
//p += GradientNoise(p / s);
//p %= GradientNoise(p / s);
//p *= GradientNoise(p / s);

//p = round(p / s) * s;
float result = p.x + p.y + p.z;
//float result = length(p);
result *= s.w;

result = (sin(result) + 1) / 2;

return vec4(result, result, result, 1);
}

//Work inprogress
vec4 MetalText (vec3 p, vec4 s)
{

//p = Rotate3D(p, PerlinNoise(p, s) * 360);
//p = Rotate3D(p, noise(round(p / s) * s) * 360);

float result = p.x + p.y + p.z;

result = (sin(result)+ 1) / 2;
return vec4(result, result, result, 0);
}


//SimpleCellularNoise
vec4 RubberTex (vec3 p, vec4 s)
{
p = abs(p);
float result = 0;

float distance = 1;
//vec3 newP = vec3(0, 0, 0);

ivec3 i = ivec3(0, 0, 0);

for (; i.x < 3; i.x++)
{

for (; i.y < 3; i.y++)
{

for (; i.z < 3; i.z++)
{

vec3 newP = vec3(round(p.x / s.x + i.x - 1) * s.x, round(p.y / s.y + i.y - 1) * s.y, round(p.z / s.z + i.z - 1) * s.z);
vec3 random = vec3(PseudoRandom(newP.y + newP.z), PseudoRandom(newP.x + newP.z), PseudoRandom(newP.x + newP.y));
//vec3 random = vec3();
newP += vec3((random.x - 0.5) * s.x * 2, (random.y - 0.5) * s.y * 2, (random.z - 0.5) * s.z * 2);

distance = min(length(p - newP), distance);
}
i.z = 0;

}
i.y = 0;

}

//distance *= 100;
result = (sin(distance) + 1) / 2;
return vec4(result, result, result, 0);
}

//REGULAR TEXTURES (NO NOISE)

vec4 SquarePattern(vec3 p, vec4 s)
{
p = SquareSpaceLoop(p.xyz, s.xyz);

p = abs(p);
return max(p.x / s.x / 2, max(p.y / s.y / 2, p.z / s.z / 2));
}


vec4 StripesBoxTexture (vec3 p)
{
p = abs(p);
float result = (sin(p.x + p.y + p.z) + 1) / 2;

return vec4(result, result, result, 0);
}

vec4 StripesSphereTexture (vec3 p)
{

float result = (sin(length(p)) + 1) / 2;

return vec4(result, result, result, 0);
}

vec4 TexMarching (vec3 Input, int type, vec4 texColor, vec4 texScale)//inout vec4 FinalColor)
{
	vec4 result = vec4(0, 0, 0, 1);

	vec4 HueColor = ColorToHue(texColor);
	
	if (type == 0)
	{
	//result = vec4(1, 1, 1, 0);
	return texColor;
	} 
	else if (type == 1)
	{
	//return texColor;
	result = StripesSphereTexture(Input);
	} 
	else if (type == 2)
	{
	result = StripesBoxTexture(Input);
	} else if (type == 3)
	{
	result = BrickTexture(Input, texScale);
	} else if (type == 4)
	{
	result = NoiseTex(Input, texScale);
	} else if (type == 5)
	{
	result = WoodTex(Input, texScale);
	} else if (type == 6)
	{
	result = MetalText(Input, texScale);
	} else if (type == 7)
	{
	//result = HeightIndicator(Input);
	//result = SquarePattern(Input, TextureScale[Index]);
	}

	HueColor.y *= result.x;
	//return result * TextureColor[Index] * 2;
	
	//FinalColor = result * TextureColor[Index];
	//return;

	return HueToColor(HueColor);
	//return texColor;
}