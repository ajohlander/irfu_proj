function [pefPart, deltaT, newPhi] = getPartSpin(pef, middleIndex, m, phi)
%ANJO.GETPARTSPIN Get a partial spin
%   pefPart = ANJO.GETPARTSPIN(pef,middleIndex, m, phi) returns ion data from a
%   partial spin fromthe initial full spin pef with middleIndex is the
%   center. m is the number of phi values in pefPart resulting in
%   size(pefPart) = [8,m,31]. phi is the vector of phi values corresponding
%   to the full spin pef.
%
%   [pefPart, deltaT] = ANJO.GETPARTSPIN(pef,middleIndex, m, phi) also returns
%   the change in time from the start of pef to pefPart.
%
%   [pefPart, deltaT, newPhi] = ANJO.GETPARTSPIN(pef,middleIndex, m, phi) also
%   returns a vector with new values for phi, corresponding to the new
%   partial spin.
%
%   See also ANJO.GETCOMBSPIN.

if (middleIndex - ceil(m/2) > 1 || middleIndex + ceil(m/2) < 16)    
    if (m/2 == ceil(m/2))             % is even
        startInd = middleIndex - m/2;
        stopInd = middleIndex + m/2 - 1;
    else                                    % is odd
        startInd = middleIndex - m/2 + 0.5;
        stopInd = middleIndex + m/2 - 0.5;
    end
    
    pefPart = pef(:,startInd:stopInd,:);
    if nargout==2
        deltaT = (startInd-1)*4.02/16;
    elseif nargout == 3
        deltaT = (startInd-1)*4.02/16;
        newPhi = phi(startInd:stopInd);
    end
else
    disp('Does not work');
    pefPart = 0;


end

