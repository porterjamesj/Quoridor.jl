# implementations of Graphs.jl interface methods

using Graphs
using Iterators

# basic
Graphs.is_directed(game::Game) = false
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
    adjacent_locs = adjacent(loc)
    ret = Edge{Loc}[]
    for adj in adjacent(loc)
        if !isoutofbounds(adj) && neighbors(game, loc, adj)
            push!(ret, Edge(0,loc,adj)) # note: index is bogus
        end
    end
    return ret
end
# source and target have fallbacks for Edge
Graphs.implements_incidence_list(game::Game) = true
