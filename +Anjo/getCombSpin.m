function [pefComb, deltaT, newPhi] = getCombSpin(pef1, pef2, middleIndex, phi)
%ANJO.GETCOMBSPIN Combines ion data from two spins
%   pefComb = ANJO.GETCOMBSPIN(pef1, pef2, middleIndex, phi) returns ion
%   data for a new spin combined from pef1 and pef2 with pef2(middleIndex)
%   as the center, middleIndex must be lower than 8.  pefComb, pef1 and
%   pef2 both have size = [8,16,31]. phi is the vector containing values
%   for the angle phi for both spins.
%
%   [pefComb, dT] = ANJO.GETCOMBSPIN(pef1, pef2, middleIndex, phi) also
%   returns the change in time from the start of pef1 to the start of
%   pefComb.
%
%   [pefComb, dT, newPhi] = ANJO.GETCOMBSPIN(pef1, pef2, middleIndex, phi)
%   also returns a vector with new values for phi, corresponding to the new
%   spin.
%
%   See also ANJO.GETPARTSPIN.

pefComb = zeros(8,16,31);
SPIN_TIME = 4.016; %s


if( middleIndex <= 8)
    startInd = 8 + middleIndex;
    stopInd = middleIndex + 7;
else
    startInd = middleIndex - 8;
    stopInd = middleIndex - 9;
end

pefComb(:,1:(17-startInd),:) = pef1(:,startInd:16,:);
pefComb(:,(18-startInd):16,:) = pef2(:,1:stopInd,:);

if(nargout == 2)
    deltaT = (7+middleIndex) *SPIN_TIME/16;
    
elseif(nargout == 3)
    deltaT = (7+middleIndex) *SPIN_TIME/16;
    newPhi = [phi(startInd:16), phi(1:stopInd)];
end


