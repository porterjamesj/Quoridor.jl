module Quoridor

using Graphs

const BOARD_MAX = 10
const BOARD_MIN = 1

@enum Player Player1=1 Player2=-2

function other(p::Player)
    return Player(~Int(p))
end

rand(::Type{Player}) = rand(Bool) ? Player1 : Player2

"""
# Loc

a two-dimensional point (x, y). represents a location on a Quoridor
board

"""
immutable Loc
    x::Int
    y::Int
end


"""
# Wall

A `Wall` is a pair of `Loc`s with sanity-check style restrictions

"""
immutable Wall
    a::Loc
    b::Loc

    # TODO figure out a way to turn this off
    # to avoid the performance hit of constructing
    function Wall(a::Loc, b::Loc)
        # cannot be on edges of board
        @assert ! ((a.x == b.x == BOARD_MAX) ||
                   (a.x == b.x == BOARD_MIN) ||
                   (a.y == b.y == BOARD_MAX) ||
                   (a.y == b.y == BOARD_MIN))

        # must be vertical or horiontal and of length 2
        @assert (a.x == b.x && (abs(a.y - b.y) == 2)) ||
                (a.y == b.y && (abs(a.x - b.x) == 2))

        # TODO sort before returning?
        return new(a, b)
    end
end

function blocks(wall::Wall, move::PlayerMove)
    # TODO implement
end


function blocks(wall::Wall, move::WallPlacement)
    # TODO implement
end

"Encapsulates the state of a given player"
type PlayerState
    loc::Loc
    walls::Int
end

PlayerState(loc::Loc) = PlayerState(loc, 10)

loc(ps::PlayerState) = ps.loc

function moveto!(p::PlayerState, loc::Loc)
    p.loc = loc
end


abstract Move

# note that we don't have to keep track of which player made a move on
# the move itself, since we can always figure out how to take the last
# move back from the global game state: whoever's turn it *isn't* made
# the move we're trying to take back

immutable WallPlacement <: Move
    wall::Wall
end

immutable PlayerMove <: Move
    from::Loc
    to::Loc
end



"""
# Game

Encapsulates the state of a Quoridor game.
"""
type Game
    walls::Vector{Wall}
    p1::PlayerState
    p2::PlayerState
    active::Player
end

initstate(::Type{Val{Player1}}) = PlayerState(Loc(1,5))
initstate(::Type{Val{Player}}) = PlayerState(Loc(9,5))

Game() = Game(Wall[], initstate(Player1), initstate(Player2), rand(Player))

"return a copy of `game`, nothing shared with the original"
copy(game::Game) = Game(copy(walls), p1, p2, turn)

active(game::Game) = game.turn
inactive(game::Game) = other(game.turn)

"return the current list of walls"
walls(game::Game) = game.walls

"return the state of a given player"
function playerstate(game::Game, player::Player)
    if player == Player1
        game.p1
    else
        game.p2
    end
end


# applying and un-applying moves to games

function apply!(game::Game, pm::PlayerMove)
    # TODO implement
end

function apply!(game::Game, wp::WallPlacement)
    # TODO implement
end

# note that these are not time-invariant: they assume the move being
# taken back is the most recent move made to bring the game to it's
# current state

function takeback!(game::Game, pm::PlayerMove)
    # TODO implement
end

function takeback!(game::Game, wp::WallPlacement)
    # TODO implement
end

apply(game::Game, move::Move) = apply!(copy(Game), move)
takeback(game::Game, move::Move) = takeback!(copy(Game), move)



# generate the set of all legal moves for a given game
function legalmoves(game::Game)
    ret = Move[] # TODO this is going to be slow, should eventually
                 # replace with a struct that distinguishes between
                 # wall placements and player moves and return that,
                 # or work up an encoding of both types of moves in a
                 # single bitstype and return a Vector of that
    apend!(ret, playermoves(game))
    append!(ret, wallplacements(game))
    return ret
end

function playermoves(game::Game)
    loc = loc(active(game))
    # TODO
    # tentative plan for this looks something like
    # potential_moves = every square adjacent to us
    # moves = PlayerMove[]
    # for move in potentival_moves
    #     for wall in walls
    #         if !blocks(wall, move)
    #             push!(moves, move)
    #         end
    #    end
    # end
    #
    # and then repeat that from the opponents square if the opponent
    # is at any of the potential move locs, fixing up the resulting
    # moves so that the original location is correct (as the move is a
    # jump)
end

end # module
