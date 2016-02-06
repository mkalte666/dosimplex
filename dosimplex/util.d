/**
    Holds utility functions for the OpenSimplex Implementation - original source and implementation: https://gist.github.com/KdotJPG/b1270127455a94ac5d19 and http://uniblock.tumblr.com/
    Additional functions that might appear are also here
*/
module dosimplex.util;


/// fastFloor floors a double into an int - like floor but with builtIn conversion
@nogc pure @safe int fastFloor(double x)
{
    int xi = cast(int)x;
    return x < xi ? xi - 1 : xi;
}

/**
    Gradients for the noise functions
*/
enum GRADIENTS : byte[] {
    /** Gradients for 2D. They approximate the directions to the
    *   vertices of an octagon from the center.
    */
    GRADIENTS_2D = [
        5,  2,    2,  5,
        -5,  2,   -2,  5,
        5, -2,    2, -5,
        -5, -2,   -2, -5,
    ],

    /**  Gradients for 3D. They approximate the directions to the
    *    vertices of a rhombicuboctahedron from the center, skewed so
    *    that the triangular and square facets can be inscribed inside
    *    circles of the same radius.
    */
    GRADIENTS_3D = [
        -11,  4,  4,     -4,  11,  4,    -4,  4,  11,
        11,  4,  4,      4,  11,  4,     4,  4,  11,
		-11, -4,  4,     -4, -11,  4,    -4, -4,  11,
        11, -4,  4,      4, -11,  4,     4, -4,  11,
		-11,  4, -4,     -4,  11, -4,    -4,  4, -11,
        11,  4, -4,      4,  11, -4,     4,  4, -11,
		-11, -4, -4,     -4, -11, -4,    -4, -4, -11,
        11, -4, -4,      4, -11, -4,     4, -4, -11,
    ],

    /**     Gradients for 4D. They approximate the directions to the
    *       vertices of a disprismatotesseractihexadecachoron from the center,
    *       skewed so that the tetrahedral and cubic facets can be inscribed inside
    *       spheres of the same radius.
    */
    GRADIENTS_4D = [
        3,  1,  1,  1,      1,  3,  1,  1,      1,  1,  3,  1,      1,  1,  1,  3,
	    -3,  1,  1,  1,     -1,  3,  1,  1,     -1,  1,  3,  1,     -1,  1,  1,  3,
        3, -1,  1,  1,      1, -3,  1,  1,      1, -1,  3,  1,      1, -1,  1,  3,
	    -3, -1,  1,  1,     -1, -3,  1,  1,     -1, -1,  3,  1,     -1, -1,  1,  3,
        3,  1, -1,  1,      1,  3, -1,  1,      1,  1, -3,  1,      1,  1, -1,  3,
	    -3,  1, -1,  1,     -1,  3, -1,  1,     -1,  1, -3,  1,     -1,  1, -1,  3,
        3, -1, -1,  1,      1, -3, -1,  1,      1, -1, -3,  1,      1, -1, -1,  3,
	    -3, -1, -1,  1,     -1, -3, -1,  1,     -1, -1, -3,  1,     -1, -1, -1,  3,
        3,  1,  1, -1,      1,  3,  1, -1,      1,  1,  3, -1,      1,  1,  1, -3,
	    -3,  1,  1, -1,     -1,  3,  1, -1,     -1,  1,  3, -1,     -1,  1,  1, -3,
        3, -1,  1, -1,      1, -3,  1, -1,      1, -1,  3, -1,      1, -1,  1, -3,
	    -3, -1,  1, -1,     -1, -3,  1, -1,     -1, -1,  3, -1,     -1, -1,  1, -3,
        3,  1, -1, -1,      1,  3, -1, -1,      1,  1, -3, -1,      1,  1, -1, -3,
	    -3,  1, -1, -1,     -1,  3, -1, -1,     -1,  1, -3, -1,     -1,  1, -1, -3,
        3, -1, -1, -1,      1, -3, -1, -1,      1, -1, -3, -1,      1, -1, -1, -3,
	    -3, -1, -1, -1,     -1, -3, -1, -1,     -1, -1, -3, -1,     -1, -1, -1, -3,
    ]
}