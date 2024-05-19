//#version 460 core
//layout(local_size_x = 8, local_size_y = 4, local_size_z = 1) in;
//layout(rgba32f, binding = 0) uniform image2D screen;

//calculates SDF for all objects in the scene
float SignedDistanceField(vec3 rayOr, inout int HitObject)
{
	float finalDist = 10000; //just big enougth
	float resultDist = 1;

	for (int i = 0; i < ObjectsCap; i++)
	{
		//positioning, rotating and scaling object
		vec3 localPos = rayOr - ShapePosition[i];

		//rotating
		localPos = Rotate3D(localPos, ShapeRotation[i]);

		//scaling is beaing executed inside primitives functions

		//calculate specyfic shape type
		resultDist = SingleShape(localPos, ShapeScale[i], ShapeType[i]);
	
		//re-scaling
		resultDist *= min(ShapeScale[i].x, min(ShapeScale[i].y, ShapeScale[i].z));

		//connecting shapes:
		float distMeter = finalDist;

		finalDist = SingleConnection(finalDist, resultDist, ConnectType[i], ConnectFactor[i]);

		//this switches the id of corresponding hitted object
		if (distMeter != finalDist)
		{
			HitObject = i;
		}
	}
	return finalDist;
}

float SoftShadow(vec3 ro, vec3 rd, float minT, float maxT, float k)
{
	float result = 1.0;
	for (float t = minT; t < maxT;)
	{
		int hit;
		float h = SignedDistanceField(ro + rd * t, hit);
		if (h < 0.001)
		{
			return 0.0;
		}
		result = min(result, k * h / t);
		t += h;
	}

	return result;
}


vec3 Shading (vec3 p, vec3 n)
{
//DirectionalLight
//float result = 1.0;
//float result = Dot3(-LightDir, n);
//vec3 result = LightColor;
vec3 result = (LightColor.xyz * Dot3(-LightDir, n)  * 0.5f + 0.5f) * LightIntensity;
//float result = (LightColor * Dot3(-LightDir, n) * 0.5f + 0.5f) * LightIntensity;

//float shadow = 1.0;
float shadow = SoftShadow(p, -LightDir, ShadowDistance.x, ShadowDistance.y, ShadowSoftness) * 0.5f + 0.5f;
shadow = max(0.0f, pow(shadow, ShadowIntensity));

return result * shadow;
}


//here goes functions to make it pretty
vec3 GetNormal(vec3 p)
{
int hit = 0; //this is unused in this case
vec3 offset1 = vec3(0.001, 0.0, 0.0);
vec3 offset2 = vec3(0.0, 0.001, 0.0);
vec3 offset3 = vec3(0.0, 0.0, 0.001);
vec3 n = vec3(SignedDistanceField(p + offset1, hit) - SignedDistanceField(p - offset1, hit), 
SignedDistanceField(p + offset2, hit) - SignedDistanceField(p - offset2, hit), 
SignedDistanceField(p + offset3, hit) - SignedDistanceField(p - offset3, hit));

return normalize(n);
}

//returns color
vec4 SphereTracing(vec3 rayOr, vec3 rayDir, inout vec4 HitPoint)
{
	vec3 rayPos = rayOr;
	//float tolerance = 0.015625;
	//float tolerance = 0.000001;
	//float tolerance = 1;
	int maxIter = 100;
	int hitObject = 0;
	for (int i = 0; i < MaxIter; i++)
	{
		//calculate objects
		//testing sphere for now
		//float result = SphereShape(rayPos - vec3(0, 0, -5), vec4(1, 1, 1, 0));
		float result = SignedDistanceField(rayPos, hitObject);

		//moving along the ray
		if (result <= Tolerance)
		{
		//hitted



		//textures: (global)
		vec4 tex = TexMarching(rayPos, TextureType[hitObject], TextureColor[hitObject], TextureScale[hitObject]);
		//vec4 tex = TextureColor[hitObject];
		//vec4 tex = vec4(1.0, 1.0, TextureType[hitObject], 0.0);

		//shading
		vec3 n = GetNormal(rayPos);
		vec3 s = Shading(rayPos, n);
		tex = vec4(tex.xyz * s, tex.w);

		//return hitObject;
		return tex;
		//return vec4(1.0, 1.0, hitObject, 0.0);
		}
		rayPos += rayDir * result;
	}
	return MainColor;
}

void main()
{
	//vec4 color = vec4(0.075, 0.133, 0.173, 1.0);
	vec4 color = MainColor;
	ivec2 pixel_coords = ivec2(gl_GlobalInvocationID.xy);
	
	ivec2 dims = imageSize(screen);
	//converts pix pos to -1 1 bound
	//vec2 uv = vec2((float(pixel_coords.x * 2 - dims.x) / dims.x), (float(pixel_coords.y * 2 - dims.y) / dims.y));
	vec2 uv = vec2((float(pixel_coords.x * 2 - dims.x) / min(dims.x, dims.y)), (float(pixel_coords.y * 2 - dims.y) / min(dims.x, dims.y)));

	float fov = 90.0;
	vec3 camPos = vec3(0.0, 0.0, 0.0);
	vec3 rayOr = vec3(0.0, 0.0, 2.0);
	vec3 rayDir = normalize(vec3(uv, -tan(fov / 2.0)));

	//here goes main rendering algorithm
	vec4 HitPoint = vec4(0, 0, 0, 0);
	/*
	if (SphereTracing(rayOr, rayDir, HitPoint) != -1)
	{
		//color = vec4(1, 1, 1, 0);
		//color = vec4(HitPoint.w, HitPoint.w, HitPoint.w, 0);
		//color = HitPoint;
	}
	*/

	color = SphereTracing(rayOr, rayDir, HitPoint);

	imageStore(screen, pixel_coords, color);
}