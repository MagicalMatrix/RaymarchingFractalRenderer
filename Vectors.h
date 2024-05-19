#pragma once

template <class T>
struct vect2
{
	T x = T(0);
	T y = T(0);

	vect2()
	{
		x = 0;
		y = 0;
	}

	vect2(T x, T y) : x(x), y(y)
	{
	}

	T length()
	{
		return sqrt(x * x + y * y);
	}

	T dist(vect2<T> other)
	{
		T xdiff = other.x - x;
		T ydiff = other.y - y;
		return sqrt(xdiff * xdiff + ydiff * ydiff);
	}
};

template <class T>
struct vect3
{
	T x = T(0);
	T y = T(0);
	T z = T(0);

	vect3()
	{
		x = 0;
		y = 0;
		z = 0;
	}

	vect3(T x, T y, T z) : x(x), y(y), z(z)
	{
	}

	T length()
	{
		return sqrt(x * x + y * y + z * z);
	}

	//unused
	T dist(vect3<T> other)
	{
		T xdiff = other.x - x;
		T ydiff = other.y - y;
		return sqrt(xdiff * xdiff + ydiff * ydiff);
	}
};

template <class T>
struct vect4
{
	T x = T(0);
	T y = T(0);
	T z = T(0);
	T w = T(0);

	vect4()
	{
		x = 0;
		y = 0;
		z = 0;
		w = 0;
	}

	vect4(T x, T y, T z, T w) : x(x), y(y), z(z), w(w)
	{
	}

	T length()
	{
		return sqrt(x * x + y * y + z * z + w * w);
	}

	//unused
	T dist(vect4<T> other)
	{
		T xdiff = other.x - x;
		T ydiff = other.y - y;
		return sqrt(xdiff * xdiff + ydiff * ydiff);
	}
};