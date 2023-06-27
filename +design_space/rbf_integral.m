function Phi_int=rbf_integral(Xc,X1,X2,k_i,basisfunction)
%Phi_int=rbf_integral(Xc,X1,X2,k_i,basisfunction)
%Calculates a line integral between X1 [x y] and X2 for an unweighted
%radial basis function with center Xc.
%basis function may be 'gaussian' or 'polyharmonicspline'
%If 'gausian' k_i is a vector of prescalers,
%If 'polyharmonicspline', k_i is a vector of the function order (1 or 3).
%Set k_i(i)=0 for bias integral is the length from X1 to X2).
%

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
    k_i=1;%prescaler
end

if nargin<5
    basisfunction='gaussian';
end

N_r=size(Xc,1);%number of centres
N_p=size(X1,1);%number of points

if numel(k_i)==1
    switch basisfunction
        case {'gaussian','Gaussian'}
            k_i=k_i*ones(N_r,1);%if k_i was a single value
        case {'phs','polyharmonicspline'}
            k_i=k_i*ones(N_r,2);%if k_i was a single value
    end
end

Phi_int=zeros(N_p,N_r);%allocate memory

for k=1:N_p
    for i=1:N_r
        if k_i(i,1)==0
            Phi_int(k,i)=sqrt(sum((X1(k,:)-X2(k,:)).^2));%if k_i=0, just calculate the length between X1 and X2
        else
            switch basisfunction
                case {'gaussian','Gaussian'}
                    p1=-((Xc(i,1)-X1(k,1))*(X2(k,1)-X1(k,1))+(Xc(i,2)-X1(k,2))*(X2(k,2)-X1(k,2)))/sqrt((X2(k,1)-X1(k,1))^2+(X2(k,2)-X1(k,2))^2);%distance from p1 to point on line nearest Xc
                    p2=-((Xc(i,1)-X2(k,1))*(X2(k,1)-X1(k,1))+(Xc(i,2)-X2(k,2))*(X2(k,2)-X1(k,2)))/sqrt((X2(k,1)-X1(k,1))^2+(X2(k,2)-X1(k,2))^2);
                    Xi=X1(k,:)+p1*(X1(k,:)-X2(k,:))/sqrt(sum((X1(k,:)-X2(k,:)).^2));%point in line closest to centre
                    q=sqrt(sum((Xc(i,:)-Xi).^2));%distance from point Xc to line
                    Phi_int(k,i)=exp(-k_i(i)*q.^2)*sqrt(pi/(4*k_i(i)))*(erf(sqrt(k_i(i))*p2)-erf(sqrt(k_i(i))*p1));

                case {'phs','polyharmonicspline'}
                    p1=-((Xc(i,1)-X1(k,1))*(X2(k,1)-X1(k,1))+(Xc(i,2)-X1(k,2))*(X2(k,2)-X1(k,2)))/sqrt((X2(k,1)-X1(k,1))^2+(X2(k,2)-X1(k,2))^2);%distance from p1 to point on line nearest Xc
                    p2=-((Xc(i,1)-X2(k,1))*(X2(k,1)-X1(k,1))+(Xc(i,2)-X2(k,2))*(X2(k,2)-X1(k,2)))/sqrt((X2(k,1)-X1(k,1))^2+(X2(k,2)-X1(k,2))^2);
                    Xi=X1(k,:)+p1*(X1(k,:)-X2(k,:))/sqrt(sum((X1(k,:)-X2(k,:)).^2));%point in line closest to centre
                    q=sqrt(sum((Xc(i,:)-Xi).^2));%distance from point Xc to line

                    switch k_i(i)
                        case 1
                            Phi_int(k,i)=-1/2*p1*(q^2+p1^2)^(1/2)-1/2*q^2*log(p1+(q^2+p1^2)^(1/2))+1/2*p2*(q^2+p2^2)^(1/2)+1/2*q^2*log(p2+(q^2+p2^2)^(1/2));
                        case 3
                            Phi_int(k,i)=-5/8*q^2*p1*(q^2+p1^2)^(1/2)-1/4*p1^3*(q^2+p1^2)^(1/2)-3/8*q^4*log(p1+(q^2+p1^2)^(1/2))+5/8*q^2*p2*(q^2+p2^2)^(1/2)+1/4*p2^3*(q^2+p2^2)^(1/2)+3/8*q^4*log(p2+(q^2+p2^2)^(1/2));
                        otherwise
                            error('PHS order must be 1 or 3')
                    end
                otherwise
                    error('unknown basis function')
            end
        end
    end
end


