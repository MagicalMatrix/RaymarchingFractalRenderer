//THIS FILE HAS TO GO FIRST!!!!!
//it contains necessary first shader lines
#version 460 core
layout(local_size_x = 8, local_size_y = 4, local_size_z = 1) in;
layout(rgba32f, binding = 0) uniform image2D screen;

uniform vec4 MainColor;

//generals
uniform int ObjectsCap; //shows how many objects are currently in the scene
uniform int MaxIter; //max iterations before giving up
uniform float Tolerance; //quality of drawn objects

uniform vec3 LightDir;
uniform vec4 LightColor;
uniform float LightIntensity;
uniform float ShadowIntensity;
uniform float ShadowSoftness;
uniform vec2 ShadowDistance;

//object positioning
uniform vec3 ShapePosition [100];
uniform vec3 ShapeRotation [100];
uniform vec4 ShapeScale [100];

//identifiers
uniform int ShapeType[100];
uniform int ConnectType[100];
uniform float ConnectFactor[100];

//textures
uniform int TextureType[100];
uniform vec4 TextureColor[100];
uniform vec4 TextureScale[100];