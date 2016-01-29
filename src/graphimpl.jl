# implementations of Graphs.jl interface methods

using Graphs
using Iterators

# basic
Graphs.is_directed(game::Game) = true
Graphs.vertex_type(game::Game) = Loc
Graphs.edge_type(game::Game) = Edge{Loc}

# vertex map
Graphs.vertex_index(loc::Loc, game::Game) = 9*(loc.x-1) + loc.y
Graphs.implements_vertex_map(game::Game) = true

# vertex list
Graphs.num_vertices(game::Game) = 81
Graphs.vertices(game::Game) = map(Loc, product(1:9, 1:9))
Graphs.implements_vertex_list(game::Game) = true

# # edge map
Graphs.edge_index(edge::Edge{Loc}, game::Game) = error("nope")
Graphs.implements_edge_map(game::Game) = true

# incidence_list
Graphs.out_degree(loc::Loc, game::Game) = length(out_edges(loc, game))
function Graphs.out_edges(loc::Loc, game::Game)
    ret = Edge{Loc}[]
    for dir in DIRS  # this comes from loc.jl just fyi
        adj = dir(loc)
        if neighbors(game, loc, adj)
            if !occupied(game, adj) && inbounds(adj)
                push!(ret, Edge(0, loc, adj))
            else
                # consider jumps
                #
                # first we need to check if it's possible to jump
                # directly over the piece occupying that space
                #
                # one thing to note is that we don't need to consider
                # the possibility of a space we're jumping to being
                # occupied (since we already know where both players
                # are)
                straight_jump = dir(adj)
                adj, straight_jump
                if (neighbors(game, adj, straight_jump) &&
                    inbounds(straight_jump))
                    push!(ret, Edge(0, loc, straight_jump))
                else
                    # consider each of the two possible perpendicular jumps
                    for perp_dir in PERPENDICULAR[dir]
                        perp_jump = perp_dir(adj)
                        @show dir, perp_dir, adj, perp_jump
                        if ((@show neighbors(game, adj, perp_jump)) &&
                            inbounds(perp_jump))
                            push!(ret, Edge(0, loc, perp_jump))
                        end
                    end
                end
            end
        end
    end
    return ret
end

# source and target have fallbacks for Edge
Graphs.implements_incidence_list(game::Game) = true
