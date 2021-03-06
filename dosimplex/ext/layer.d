module dosimplex.ext.layer;

/// Layer interface used by all kinds of layers
interface Layer
{
    @nogc @safe pure double eval(D...)(D dimensions);
}

/// Default layer for open simplex noise
class OpenSimplexNoiseLayer : Layer
{
    import dosimplex.generator;
    import dosimplex.seed;

    this(Seed s)
    {
        _gen = SNoiseGenerator(s);
    }

    @nogc @safe pure double eval(D...)(D dimensions)
    if (dimensions.length > 0 && dimensions.length < 5)
    {
        static if (dimensions.length == 1) {
            return _gen.noise2D(dimensions,0.0); // TODO: im unhappy with this.
        } else static if (dimensions.length == 2) {
            return _gen.noise2D(dimensions);
        } else static if (dimensions.length == 3) {
            return _gen.noise3D(dimensions);
        } else static if (dimensions.length == 4) {
            return _gen.noise4D(dimensions);
        }

        assert(0);
    }

private:
    SNoiseGenerator _gen;
}

/// Default layer for sine function
class SineLayer : Layer 
{
    @nogc @safe pure double eval(D...)(D dimensions)
    if (dimensions.length > 0 && dimensions.length < 5)
    {
        import std.math;
        double result = 0.0;    // we dont set to 1.0 and then just multiply to avoid this tiny bit of error it might cause - and its probably a tiny bit faster
        foreach(int i,d; dimensions) {
            static if(i < 1) {
                result = sin(d);
            } else {
                result = result*sin(d);
            }
        }

        return result;
    }
}

