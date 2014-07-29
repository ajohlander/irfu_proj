function [v,n] = slamsFit(R,t)
% ANJO.SLAMSFIT fits the plane wave's velocity and normal vector from 
% time and position data.
%
%   [v,n] = ANJO.SLAMSFIT(R,t) returns the normal vector n and the velocity
%   along this vector v from the a position matrix R, and the time vector at
%   which the spacecrafts saw the SLAMS t. Works for any planar structure
%   where v||n.

X = [R(:,2)-R(:,1),R(:,3)-R(:,1),R(:,4)-R(:,1)];
tMod = [t(2)-t(1),t(3)-t(1),t(4)-t(1)];
beta = nlinfit(X,tMod,@Anjo.planeFun,[1,1,1]);

v = sqrt(sum(beta.^2));
n = beta/v;

end

