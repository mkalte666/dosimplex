/**
    Holds seed and seeding helpers
*/
module dosimplex.seed;

/**
    A seed is the seed (tadaa) for all procedual generations inside the engine. 
    It can be initialized with all types of input, always resulting in a long as representation.
    Also there is a fixed conversion into float/double and other types
*/
struct Seed
{
    /// Constructs a Seed with a native uint as input
    @nogc this(long s) 
    {
        _seed = s;
    }

    /// Construct from a input string. Now here things become interesting
    @nogc this(string s)
    {
        this.seed = s;
    }


    /// gets the seed
    @nogc @safe @property long seed() const
    {
        return _seed;
    }
    /// sets the seed
    @nogc @safe @property long seed(long s) 
    {
        return _seed=s;
    }
    /// sets the seed from string
    /// uses djb2 - http://www.cse.yorku.ca/~oz/hash.html
    @nogc @safe @property long seed(string s)
    {
        _seed = 5381;
        foreach(c; s) {
            _seed = ((_seed << 5) + _seed) + c; // hash * 33 + c 
        }

        return _seed;
    }
    
    /// returns the floating point represenatation of this seed
    @nogc @safe @property float fSeed() const
    {
        return cast(float)_seed;
    }

    /// Ditto
    @nogc @safe @property double dSeed() const
    {
        return cast(double)_seed;
    }
    

private:
    /// The seed generated/stored
    long _seed = 1787569; // we default to a somehow shitty seed we just say is random - 1337^2
}