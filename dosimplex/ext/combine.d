/**
    Combinition functions for two layers
*/
module dosimplex.ext.combine;

import dosimplex.ext.layer;

alias LayerCombineFunc = double function(double,double);

@nogc @safe pure double CombineLayers(D : uint,L...) (LayerCombineFunc f,lazy L args)
if ( D > 1 && D < 4 && args.length > D+2)
{
    auto layers = args[D..$];
    auto dimensions = args[0..D];

    // check type for the dimensions
    foreach(d;dimensions) {
        static assert(is(typeof(d)==double));
    }
    // check layers
    foreach(a;layers) {
        import std.traits;
        static assert(isInstanceOf(a,Layer)||is(typeof(a)==double));
    }

    double result = f(layers[0].eval!D(dimensions),layers[1].eval!D(dimensions));
    for(size_t i=2;i<layers.length;i++) {
        result = f(result,layers[i].eval!D(dimensions));
    }

    return result;
}

/// Parallely combines layers. 
@safe pure double[] ParralelCombineLayers(D : uint,L...) (LayerCombineFunc l, double offset, size_t size, lazy L args)
if ( D > 1 && D < 4 && args.length > D+2 && size > 0)
{
    auto layers = args[D..$];
    auto dimensions = args[0..D];

    // check type for the dimensions
    foreach(d;dimensions) {
        static assert(is(typeof(d)==double));
    }
    // check layers
    foreach(a;layers) {
        import std.traits;
        static assert(isInstanceOf(a,Layer)||is(typeof(a)==double));
    }

    import std.math;
    import std.parallelism;
    auto result = new double[pow(size,D)];
    foreach(i, ref elem; parallel(result)) {
        auto modifiedDimensions = dimensions.idup;
        foreach(j,elem;dimensions) {
            modifiedDimensions[j] = elem+i*offset;
        }
        result[i] = f(layers[0].eval!D(dimensions),layers[1].eval!D(dimensions));
        for(size_t j=2;j<layers.length;j++) {
            result[i] = f(result[i],layers[j].eval!D(dimensions));
        }
    }
    return result;
}

/// Default add combine
@nogc @safe pure double AddCombineLayers(D : uint,L...) (lazy L args)
{
    CombineLayers!D(function (double l,double r) => l+r, L);
}
/// Default sub combine
@nogc @safe pure double AddCombineLayers(D : uint,L...) (lazy L args)
{
    CombineLayers!D(function (double l,double r) => l-r, L);
}
/// Default mul combine
@nogc @safe pure double MulCombineLayers(D : uint,L...) (lazy L args)
{
    CombineLayers!D(function (double l,double r) => l*r, L);
}
/// Default pow combine
@nogc @safe pure double PowCombineLayers(D : uint,L...) (lazy L args)
{
    import std.math;
    CombineLayers!D(function (double l,double r) => pow(l,r), L);
}