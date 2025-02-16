if isinteractive()
    @eval using VimBindings
    @eval using Revise
end


"""
    @entr expression
Whenever a .jl file is saved, expr will be evaluated.
"""
macro entr(x)

    return :(
        Revise.entr([".jl"]) do
            $x
        end
    )

end
