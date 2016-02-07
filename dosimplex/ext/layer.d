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
    if (dimensions.length > 1 && dimensions.length < 5)
    {
        final switch(dimensions.length) {
            case 2:     
                return _gen.noise2D(dimensions);
                break;
            case 3:
                return _gen.noise3D(dimensions);
                break;
            case 4:
                return _gen.noise4D(dimensions);
                break;
        }
    }

private:
    SNoiseGenerator _gen;
}