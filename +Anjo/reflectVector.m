function [vRefl] = reflectVector(vSW,vSLAM)
%REFLECTVECTOR Summary of this function goes here
%   Detailed explanation goes here


% Change to a coordinate system in which the SLAMS is in rest v -> v-vSLAM
nHat = vSLAM/sqrt(sum(vSLAM.^2));
vIn = vSW-vSLAM;


vN = (vIn*nHat')*nHat; %Normal component
vT = vIn-vN;    %Other component

vR = -vN+vT; %Reflection

% Change back to s/c system
vRefl = vR+vSLAM;

end

