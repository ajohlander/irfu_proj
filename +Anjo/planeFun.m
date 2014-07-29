function [ yhat ] = planeFun(beta,x)
%ANJO.PLANEFUN Function for a plane
%   yhat = ANJO.PLANEFUN(beta,x)
%
%   See also ANJO.SLAMSFIT

yhat = 1/(beta*beta')*(x'*beta')';

end