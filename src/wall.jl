"""
# Wall

A `Wall` is a pair of `Loc`s with sanity-check style restrictions

"""
immutable Wall
    bottom::Loc
    top::Loc
    center::Loc
    direction::Direction
    adjacent::Vector4{Loc}

    function Wall(a::Loc, b::Loc)

        # cannot be on edges of board
        # TODO I imagine this might eventually have to go away
        # for perf
        @assert ! ((a.x == b.x == BOARD_MAX) ||
                   (a.x == b.x == BOARD_MIN) ||
                   (a.y == b.y == BOARD_MAX) ||
                   (a.y == b.y == BOARD_MIN))

        direction = ifelse(a.x == b.x, Vertical, Horizontal)

        # TODO probably also will have to be removed for perf
        if direction == Vertical
            @assert abs(a.y - b.y) == 2
        else
            @assert abs(a.x - b.x) == 2
        end

        if a < b
            bottom, top = a, b
        else
            bottom, top = b, a
        end

        center = mean(bottom, top)
        across_from_bottom = ifelse(direction == Vertical,
                                    left(bottom), below(bottom))
        across_from_center = ifelse(direction == Vertical,
                                    left(center), below(center))
        adjacent = Vector4(bottom, center,
                           across_from_bottom,
                           across_from_center)
        new(bottom, top, center, direction, adjacent)
    end
end

# have to define this explicitly because inner constructors still dont
# call convert for you? weird
Wall(a::Tuple{Int, Int}, b::Tuple{Int, Int}) = Wall(Loc(a), Loc(b))

center(w::Wall) = w.center
bottom(w::Wall) = w.bottom
top(w::Wall) = w.top
adjacent(w::Wall) = w.adjacent

show(io::IO, w::Wall) = write(io, "($(w.bottom)---$(w.top)")


function separates(wall::Wall, l1::Loc, l2::Loc)
    adjacent_locs = adjacent(wall)
    l1 in adjacent_locs && l2 in adjacent_locs
end

function any_separates(walls::Vector{Wall}, l1::Loc, l2::Loc)
    # TODO its a shame this has to exist and I can't just use
    # Base.any, which would involve an extra allocation for the
    # intermediate boolean list
    for wall in walls
        if separates(wall, l1, l2)
            return true
        end
    end
    return false
end

function allwalls()
    ret = Wall[]
    for i in 2:9
        for j in 1:8
            bottom_x = Loc(i,j)
            top_x = above(above(bottom_x))
            push!(ret, Wall(bottom_x, top_x))
            bottom_y = Loc(j,i)
            top_y = right(right(bottom_y))
            push!(ret, Wall(bottom_y, top_y))
        end
    end
    return ret
end

ALL_WALLS = allwalls()
