"""
# Game

Encapsulates the state of a Quoridor game.
"""
type Game <: AbstractGraph{Loc, Edge{Loc}}
    walls::Vector{Wall}
    p1::PlayerState
    p2::PlayerState
    active::Player
end

initstate(::Type{Val{Player1}}) = PlayerState(Loc(5,1))
initstate(::Type{Val{Player2}}) = PlayerState(Loc(5,9))

Game() = Game(Wall[],
              initstate(Val{Player1}),
              initstate(Val{Player2}),
              rand(Player))

"return a copy of `game`, nothing shared with the original"
copy(game::Game) = Game(copy(walls), p1, p2, turn)

active(game::Game) = game.active
inactive(game::Game) = other(active(game))

"return the current list of walls"
walls(game::Game) = game.walls

getindex(game::Game, player::Player) = ifelse(player == Player1,
                                              game.p1, game.p2)


# applying and un-applying moves to games

function apply!(game::Game, pm::PlayerMove)
    # TODO implement
end

function apply!(game::Game, wp::WallPlacement)
    # TODO implement
end

# note that these are not time-invariant: they assume the move being
# taken back is the most recent move made to bring the game to it's
# current state. could avoid this by keeping a stack of made moves on
# the game

function takeback!(game::Game, pm::PlayerMove)
    # TODO implement
end

function takeback!(game::Game, wp::WallPlacement)
    # TODO implement
end

apply(game::Game, move::Move) = apply!(copy(Game), move)
takeback(game::Game, move::Move) = takeback!(copy(Game), move)

"Test if two `Loc`s are neighbors in the context of a `Game`"
function neighbors(game::Game, l1::Loc, l2::Loc)
    !any_separates(walls(game), l1, l2)
end

# generate the set of all legal moves for a given game
function legalmoves(game::Game)
    ret = Move[] # TODO this is going to be slow, should eventually
                 # replace with a struct that distinguishes between
                 # wall placements and player moves and return that,
                 # or work up an encoding of both types of moves in a
                 # single bitstype and return a Vector of that
    append!(ret, playermoves(game))
    append!(ret, wallplacements(game))
    return ret
end

function playermoves(game::Game)
    us = game[active(game)]
    them = game[inactive(game)]
    ret = PlayerMove[]
    for move in potential_moves(us)
        if isoutofbounds(move)
            # TODO maybe do this in potential_moves
            continue
        end
        if loc(them) == move.to
            # we can jump over them, this next loop ads jumps
            for move in potential_moves(them)
                if move.to != loc(us) && !any_blocks(walls(game), move)
                    push!(ret, move)
                end
            end
        else
            # these are non-jump moves
            if !any_blocks(walls(game), move)
                push!(ret, move)
            end
        end
    end
    return ret
end

function wallplacements(game::Game)
    # note that some of these placements will be illegal because they
    # block a player's path to the endzone, let's plan to filter these
    # out later because i think doing so now would be prohibitively
    # expensive? and i dont feel like writing the graph generation
    # code yet

    # TODO this is slow due to allocating the new list of placements,
    # should come back and rewrite it as an iterator but i don't feel
    # like it right now
    placements = WallPlacement[]
    for possibility in ALL_WALLS
        placement = WallPlacement(possibility)
        if !any_blocks(walls(game), placement)
            push!(placements, placement)
        end
    end
    return placements
end
