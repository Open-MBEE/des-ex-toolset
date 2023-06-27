function [t,x] = RK4( fn,tspan,x0 )
% An implementation of fixed step 4th order Runge-Kutta method

f = str2func(fn);
t = tspan;
h = tspan(2)-tspan(1);
x = zeros(6,size(tspan,2));
x(:,1) = x0;

for i = 1:size(t,2)-1
    k1 = f(t(i),x(:,i));
    k2 = f(t(i)+h/2,x(:,i)+k1*h/2);
    k3 = f(t(i)+h/2,x(:,i)+k2*h/2);
    k4 = f(t(i)+h,x(:,i)+k3*h);
    x(:,i+1) = x(:,i) + (k1 + 2*k2 + 2*k3 + k4)*h/6;
end

end