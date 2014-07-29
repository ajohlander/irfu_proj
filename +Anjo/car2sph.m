function [rSph] = car2sph(rCar)
%ANJO.CAR2SPH Transforms coordinates from cartesian to spherical
%   rSph = car2sph(rCar). rSph = [r, theta, phi], theta is polar angle
%   in [0,180] and phi is the azimuthal angle in [0,360].
%
%   See also ANJO.SPH2CAR ANJO.GSE2NMR

r = sqrt(sum(rCar.^2));
rSph = [r, acosd(rCar(3)/r), atand(rCar(2)/rCar(1))];

end