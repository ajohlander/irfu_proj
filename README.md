irfu_proj
=========
Matlab files for master thesis on ion acceleration in the quasi-parallel bow shock at IRF Uppsala. 
Author: Andreas Johlander

Installation
------------
Go to your Matlab working directory and write in the terminal:
> git clone git://github.com/ajohlander/irfu_proj.git

Usage
-----
Once +Anjo is in your working directory, run a script by typing in Matlab
> Anjo.scriptname

and a function 
> Anjo.functionname(input)

Scripts
-------
### ionplot.m ###
lorem

Functions
---------
### fastDate.m ###
**Returns a date string**

tOut = Anjo.fastDate(tIn, showMilliSeconds) returns the date of tIn,
which is in Unix time. showMilliSeconds is a boolean.

### getCombSpin.m ###
**Combines ion data from two spins**

pefComb = Anjo.getCombSpin(pef1, pef2, middleIndex, phi) returns ion 
data for a new spin combined from pef1 and pef2 with pef2(middleIndex)
as the center, middleIndex must be lower than 8.  pefComb, pef1 and 
pef2 both have size = [8,16,31]. phi is the vector containing values
for the angle phi for both spins.

[pefComb, dT] = Anjo.getCombSpin(pef1, pef2, middleIndex, phi) also 
returns the change in time from the start of pef1 to the start of
pefComb.

[pefComb, dT, newPhi] = Anjo.getCombSpin(pef1, pef2, middleIndex, phi) 
Also returns a vector with new values for phi, corresponding to the new
spin.
