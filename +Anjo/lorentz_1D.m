function [vel, xMin] = lorentz_1D(eField,bField,v0,runTime,dT,nSlams)
%LORENTZ_1D Summary of this function goes here
%   Detailed explanation goes here




n = floor(runTime/dT);

vel = zeros(n,4);


x = max(bField(:,1));
xMin = x;
vel(1,2:4) = v0;    %initial conditions


q = 1.602e-19;
mi = 1.6726e-27;


for i = 1:n-1
    v = vel(i,2:4);
    
    B = interp1(bField(:,1),bField(:,2:4),x)/1e9;
    E = interp1(eField(:,1),eField(:,2:4),x)/1e3;
    
    a = q/mi*(E + cross(v,B));
    
    v = v + a*dT;
    x = x-v*nSlams'*dT;
    
    if(x<xMin)
        xMin = x;
    end
    
    vel(i+1,:) = [vel(i,1)+dT, v];
    
end


end

