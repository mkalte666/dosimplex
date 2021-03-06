 /**
    Holds the noise generator. Mostly a copy and reimplementation of https://gist.github.com/KdotJPG/b1270127455a94ac5d19 and http://uniblock.tumblr.com/  
 */
module dosimplex.generator;

import dosimplex.osimplex2d;
import dosimplex.osimplex3d;
import dosimplex.osimplex4d;
import dosimplex.seed;
import dosimplex.util;


/**
    The noise generator. 
    somehow impelments OpenSimplexNoise - https://gist.github.com/KdotJPG/b1270127455a94ac5d19 and http://uniblock.tumblr.com/  
*/
struct SNoiseGenerator
{    
    /// (Default) Values for noise generation
    enum : long {
        DEFAULT_SEED = 1787569, /// why not
    };
    
    /// Disabled Default struct constructor
    @disable this();
    
    /// Initializes a generator from a long seed 
    @nogc @safe this(long seed)
    {
        short[256] source;
        for (short i=0; i<256; i++) {
            source[i]=i;
        }
        seed = seed * 6364136223846793005L + 1442695040888963407L;
		seed = seed * 6364136223846793005L + 1442695040888963407L;
		seed = seed * 6364136223846793005L + 1442695040888963407L;
        for (int i = 255; i >= 0; i--) {
			seed = seed * 6364136223846793005L + 1442695040888963407L;
			int r = ((seed + 31) % (i + 1));
			if (r < 0)
				r += (i + 1);
			_perm[i] = source[r];
			_permGradIndex3D[i] = cast(short)((_perm[i] % (GRADIENTS.GRADIENTS_3D.length / 3)) * 3);
			source[r] = source[i];
		}
    }
    
    /// Initializes a generator from a Seed struct 
    @nogc @safe this(Seed seed)
    {
        this(seed.seed);
    }
    
    /// Initializes a generator from a given permutation array
    @nogc @safe this(short[256] perm) 
    {
        _perm = perm;
        for (int i = 0; i < 256; i++) {
			//Since 3D has 24 gradients, simple bitmask won't work, so precompute modulo array.
			_permGradIndex3D[i] = cast(short)((_perm[i] % (GRADIENTS.GRADIENTS_3D.length / 3)) * 3);
		}
    }
    
    /// 2D OpenSimplexNoise
    @nogc @safe pure double noise2D(double x, double y)
    {
        return osNoise2D(x,y,_perm);
    }
    /// Ditto
    @nogc @safe pure double noise2D(const double[2] p)
    {
        return osNoise2D(p[0],p[1],_perm);
    }

    /// 3D OpenSimplexNoise
    @nogc @safe pure double noise3D(double x, double y, double z)
    {
        return osNoise3D(x,y,z,_perm,_permGradIndex3D);
    }
    /// Ditto
    @nogc @safe pure double noise3D(const double[3] p)
    {
        return osNoise3D(p[0],p[1],p[2],_perm,_permGradIndex3D);
    }
    
    /// 3D OpenSimplexNoise
    @nogc @safe pure double noise4D(double x, double y, double z, double w)
    {
        return osNoise4D(x,y,z,w,_perm);
    }
    /// Ditto
    @nogc @safe pure double noise4D(const double[4] p)
    {
        return osNoise4D(p[0],p[1],p[2],p[3],_perm);
    }

private:
    /// Permutation Array
    short[256] _perm;
    /// Grad index precomputed for 3D noise
    short[256] _permGradIndex3D;
}

