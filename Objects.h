#pragma once
#include "Vectors.h"
#include "LinkedList.h"

template <typename T>
struct MarchingObject
{
	vect3<T> pos;
	vect3<T> rot;
	vect4<T> scale;

	//connecting
	int shapeType; //0 point 1 sphere 2 cube 3 cylinder 4 octahedron 5 cone
	int connectType; //0 add 1 subtract 2 join 3 smooth add
	T connectFactor;

	//customs:


	//textures:
	int texType;
	vect4<T> texColor;
	vect4<T> texScale;

	//it is just empty and useless
	MarchingObject()
	{

	}

	//this will do for now
	MarchingObject(vect3<T> pos, vect3<T> rot, vect4<T> scale, int shapeType, int connectType, float connectFactor, int texType, vect4<T> texColor, vect4<T> texScale) 
		: pos(pos), rot(rot), scale(scale), shapeType(shapeType), connectType(connectType), connectFactor(connectFactor),
		texType(texType), texColor(texColor), texScale(texScale)
	{

	}
};