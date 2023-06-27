function aproxvalue = RBFapproximate(desvars)
    global GX_c
    global GRBFWeights
    global Gk_i
    global Gbasisfunction

    aproxvalue= design_space.sim_rbf(GX_c,desvars,GRBFWeights,Gk_i,Gbasisfunction);
end