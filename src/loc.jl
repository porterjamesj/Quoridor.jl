"""
# Loc

a two-dimensional point (x, y). represents a location on a Quoridor
board

"""
immutable Loc
    x::Int
    y::Int
end


(+)(l1::Loc, l2::Loc) = Loc(l1.x + l2.x, l1.y + l2.y)
(-)(l1::Loc, l2::Loc) = Loc(l1.x - l2.x, l1.y - l2.y)

# TODO bounds check on these somewhere?
left(l::Loc) = l - Loc(1,0)
right(l::Loc) = l + Loc(1,0)
above(l::Loc) = l + Loc(0,1)
below(l::Loc) = l - Loc(0,1)

const DIRS = Vector4{Function}(above, below, left, right)
const VERTICAL = Vector2{Function}(above, below)
const HORIZONTAL = Vector2{Function}(left, right)

const PERPENDICULAR = Dict(left=>VERTICAL, right=>VERTICAL,
                           above=>HORIZONTAL, below=>HORIZONTAL)

isless(l1::Loc, l2::Loc) = isless(l1.x + l1.y, l2.x + l2.y)
mean(l1::Loc, l2::Loc) = Loc((l1.x + l2.x) / 2, (l1.y + l2.y) / 2)

convert(::Type{Loc}, tup::Tuple{Int, Int}) = Loc(tup[1], tup[2])

show(io::IO, loc::Loc) = write(io, "Loc($(loc.x), $(loc.y))")


isoutofbounds(loc::Loc) = (loc.x < 1 || loc.x > 9 ||
                           loc.y < 1 || loc.y > 9)

inbounds(loc::Loc) = !isoutofbounds(loc)

function adjacent(loc::Loc)
    Vector4{Loc}(above(loc), below(loc), right(loc), left(loc))
end
