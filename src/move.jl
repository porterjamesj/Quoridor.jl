abstract Move

# note that we don't have to keep track of which player made a move on
# the move itself, since we can always figure out how to take the last
# move back from the global game state: whoever's turn it *isn't* made
# the move we're trying to take back

immutable WallPlacement <: Move
    wall::Wall
end

show(io::IO, wp::WallPlacement) = write(io, "WallPlacement$(wp.wall)")

immutable PlayerMove <: Move
    from::Loc
    to::Loc
end

show(io::IO, pm::PlayerMove) = write(io, "PlayerMove($(pm.from)->$(pm.to))")

isoutofbounds(pm::PlayerMove) = isoutofbounds(pm.to)



blocks(wall::Wall, pm::PlayerMove) = separates(wall, pm.from. pm.to)
blocks(wall::Wall, wp::WallPlacement) = center(wall) == center(move.wall)

function any_blocks(walls::Vector{Wall}, move::Move)
    # TODO it's a shame this has to duplicate any_separates
    for wall in walls
        if blocks(wall, move)
            return true
        end
    end
    return false
end
