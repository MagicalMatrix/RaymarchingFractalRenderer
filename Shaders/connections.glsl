//SimpleConnections

float Add(float dist1, float dist2)
{
return min(dist1, dist2);
}

float Subtract(float dist1, float dist2)
{
return max(dist1, -dist2);
}

float Join(float dist1, float dist2)
{
return max(dist1, dist2);
}

float Fill(float dist1, float dist2, float factor)
{

return dist1 + dist2 - factor;
}

float SmoothAdd(float dist1, float dist2, float factor)
{
float h = max(factor - abs(dist1 - dist2), 0) / factor;
return min(dist1, dist2) - h * h * h * factor * 1 / 6.0f;
}

//ok, why that?
float MathAdd(float dist1, float dist2)
{
return dist1 + dist2;
}

float SingleConnection(float dist1, float dist2, int type, float factor) //inout bool first)
{
float result = 0;

if (type == 0)
{
result = Add(dist1, dist2);
} else if (type == 1)
{
result = Subtract(dist1, dist2);
} else if (type == 2)
{
result = Join(dist1, dist2);
} else if (type == 3)
{
result = Fill(dist1, dist2, factor);
} else if (type == 4)
{
result = SmoothAdd(dist1, dist2, factor);
} else if (type == 5)
{

if (dist1 < 0 && dist2 < 0)
{
result = dist1 * abs(dist2);
} else
{
result = dist1 * dist2;
}

result = dist1 * dist2;

}

//Checking for textures input (sharp version)
/*
if (result == dist1)
{
first = true;
} else
{
first = false;
}
*/

return result;
}