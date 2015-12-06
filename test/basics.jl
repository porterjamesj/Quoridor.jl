using Quoridor
using Base.Test

Q = Quoridor
# test movement blockage

@test Q.blocks(Q.Wall((4,2), (6,2)), Q.PlayerMove((4,3), (4,2)))
