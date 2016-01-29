using Quoridor
using Base.Test

Q = Quoridor

# test movement blockage

@test !Q.separates(Q.Wall((6,1), (6,3)), Q.Loc(5,1), Q.Loc(5,2))
@test Q.separates(Q.Wall((4,3), (6,3)), Q.Loc(4,3), Q.Loc(4,2))
