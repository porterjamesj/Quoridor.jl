"Encapsulates the state of a given player"
type PlayerState
    loc::Loc
    walls::Int
end

PlayerState(loc::Loc) = PlayerState(loc, 10)

loc(ps::PlayerState) = ps.loc
walls(ps::PlayerState) = ps.walls


function potential_moves(ps::PlayerState)
    # TODO rewrite in terms of adjacent(loc::Loc). might be slower?
    our_loc = loc(ps)
    Vector4{PlayerMove}(PlayerMove(our_loc, above(our_loc)),
                        PlayerMove(our_loc, below(our_loc)),
                        PlayerMove(our_loc, right(our_loc)),
                        PlayerMove(our_loc, left(our_loc)))
end

function moveto!(p::PlayerState, loc::Loc)
    p.loc = loc
end
