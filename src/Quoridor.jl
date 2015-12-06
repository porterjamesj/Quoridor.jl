module Quoridor

import Base: (+), (-), isless, mean,convert, show, getindex, rand, start, next, done

import Graphs: AbstractGraph, Edge
using ImmutableArrays

const BOARD_MAX = 10
const BOARD_MIN = 1

@enum Player Player1=1 Player2=-1

function other(p::Player)
    return Player(-Int(p))
end

rand(::Type{Player}) = rand(Bool) ? Player1 : Player2

@enum Direction Horizontal=1 Vertical=-1

include("loc.jl")
include("wall.jl")
include("move.jl")
include("playerstate.jl")
include("game.jl")
include("graphimpl.jl")

end # module
