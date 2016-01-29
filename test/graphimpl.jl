using Quoridor
using Graphs
using Base.Test

@test out_edges(Q.Loc(4,1), g) == [Q.PlayerMove((4, 1),(4, 2))
                                   Q.PlayerMove((4, 1),(3, 1))
                                   Q.PlayerMove((4, 1),(6, 1))]
