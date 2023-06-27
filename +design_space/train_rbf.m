function [W, phi]=train_rbf(X,Y,Xc,k_i,basisfunction)
%[W, phi]=train_rbf(X,Y,Xc,k_i,basisfunction)
%trains a radial basis function
%X is a N_p by N_dim matrix of training data
%Y is a N_p by N_dim matrix of training data
%Xc is a N_r by N_dim matrix of rbf centres
%basisfunction may be 'gaussian' or 'polyharmonicspline'
%k_i is a prescaler for 'gaussian' rbf and function order for
%'polyharmonicspline'. Set k_i(i)=0 for constant bias
%Outputs weight vector as well as unweighted RBF outputs for
%training data.

%
%Copyright (c) 2014, Travis Wiens
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without 
%modification, are permitted provided that the following conditions are 
%met:
%
%    * Redistributions of source code must retain the above copyright 
%      notice, this list of conditions and the following disclaimer.
%    * Redistributions in binary form must reproduce the above copyright 
%      notice, this list of conditions and the following disclaimer in 
%      the documentation and/or other materials provided with the distribution
%      
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%POSSIBILITY OF SUCH DAMAGE.
%
% If you would like to request that this software be licensed under a less
% restrictive license (i.e. for commercial closed-source use) please
% contact Travis at travis.mlfx@nutaksas.com

if nargin<4
    k_i=1;
end

if nargin<5
    basisfunction='gaussian';
end

N_r=size(Xc,1);%number of centres

W=zeros(N_r,1);%weight matrix
[~, phi]=design_space.sim_rbf(Xc,X,W,k_i,basisfunction);%simulate rbf
%A=pinv(phi'*phi)*phi';%do inverse
%W=A*Y;
%W=phi\Y;%find weights
W=pinv(phi)*Y;