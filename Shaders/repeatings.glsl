

//Infinite space creator
//*
vec3 SquareSpaceLoop (vec3 p, vec3 s)
{

return abs(p % s) - s / 2;
//return (p + 0.5 * s) % s - 0.5 * s;
}
//*/

//returns the local position of the object
vec3 SquareSpaceRound (vec3 p, vec3 s)
{
return round(p / s) * s;
}