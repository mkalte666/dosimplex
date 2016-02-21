/**
    Combinition functions for two layers
*/
module dosimplex.ext.combine;

import dosimplex.ext.layer;

/// The alias for the signature needed by CombineLayers functions
alias LayerCombineFunc = double function(double,double) pure nothrow @nogc @safe;

/**
    Template holds functions for layer combination.
    Params:
        D = number of dimensions. Must be 0 < D <= 4
*/
template CombineLayers(uint D) 
if (D > 0 && D < 5)
{

    /**
        Generic function to combine different noise layers.
        Params:
            f = the combination function. must have a signature "double function(double,double) pure nothrow @nogc @safe"
            args = var length arguments 
                - slice 0..D is the values for the dimensions
                - D..$ is the slice with the layers - they can be double or instance of layer
    */
    @nogc @safe pure double generic(A...) (LayerCombineFunc f, A args)
    if (args.length > D+1)
    {
        auto layers = args[D..$];
        auto dimensions = args[0..D];

        // check type for the dimensions
        foreach(d;dimensions) {
            static assert(is(typeof(d)==double));
        }
        
        double result = 0.0; // we dont set to 1.0 and then just multiply to avoid this tiny bit of error it might cause - and its probably a tiny bit faster

        // check and evaluate layers
        foreach(size_t i, a;layers) {
            import std.traits;

            static if (is(typeof(a) == double)) {
                double x = a;
            }
            else if (cast(Layer)a) {
                double x = a.eval!D(dimensions);
            }
            else {
                double x = 0.0;
                pragma(msg, "Can only accept Layers and doubles as arguments for noise functions!");
                assert(false);
                
            }
            
            static if (i == 0) { // see declaration of result
                result = x;
            }
            else {
                result = f(result,x);
            }           
        }

        return result;
    }

    /**
        Adds the vlaues of each layer
        Params:
        args = var length arguments 
            - slice 0..D is the values for the dimensions
            - D..$ is the slice with the layers - they can be double or instance of layer
    */
    @nogc @safe pure double add(L...) (L args)
    {
        return CombineLayers!D.generic(function (double l,double r) => l+r, args);
    }

    /**
        Subtracts the vlaues of each layer
        Params:
            args = var length arguments 
                - slice 0..D is the values for the dimensions
                - D..$ is the slice with the layers - they can be double or instance of layer
    */
    @nogc @safe pure double sub(L...) (lazy L args)
    {
        return CombineLayers!D.generic(function (double l,double r) => l-r, args);
    }

    /**
        Multiplies the vlaues of each layer
        Params:
            args = var length arguments 
                - slice 0..D is the values for the dimensions
                - D..$ is the slice with the layers - they can be double or instance of layer
    */
    @nogc @safe pure double mul(L...) (lazy L args)
    {
        return CombineLayers!D.generic(function (double l,double r) => l*r, args);
    }

    /**
        Pows the vlaues of each layer
        Params:
            args = var length arguments 
                - slice 0..D is the values for the dimensions
                - D..$ is the slice with the layers - they can be double or instance of layer
    */
    @nogc @safe pure double pow(L...) (lazy L args)
    {
        import std.math;
        return CombineLayers!D.generic(function (double l,double r) => pow(l,r), args);
    }
}