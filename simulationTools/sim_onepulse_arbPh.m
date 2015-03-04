%sim_onepulse_arbPh.m
%Robin Simpson and Jamie Near, 2014.
%
% USAGE:
% out=sim_onepulse_arbPh(n,sw,Bfield,linewidth,sys,ph)
% 
% DESCRIPTION:
% This function simulates a pulse-acquire experiment with an ideal
% (instantaneous) excitation pulse and an assumed lorentzian lineshape.  
% The function calls the function 'sim_Hamiltonian' which produces the free
% evolution Hamiltonian for the specified number of spins, J and shifts.
% This function enables an excitation pulse with an arbitrary phase.  
% 
% INPUTS:
% n         = number of points in fid/spectrum
% sw        = desired spectral width in [Hz]
% Bfield    = main magnetic field strength in [T]
% linewidth = linewidth in [Hz]
% sys       = spin system definition structure
% ph        = excitation pulse phase (in degrees)

function out = sim_onepulse_arbPh(n,sw,Bfield,linewidth,sys,ph)

%Set water to centre
centreFreq=4.65;
sys.shifts=sys.shifts-centreFreq;

%Calculate Hamiltonian matrices and starting density matrix.
[H,d]=sim_Hamiltonian(sys,Bfield);

%BEGIN PULSE SEQUENCE************
d=sim_excite_arbPh(H,ph);                            %EXCITE
[out,dout]=sim_readout(d,H,n,sw,linewidth,90);  %Readout along y (90 degree phase);
%END PULSE SEQUENCE**************

%Correct the ppm scale:
out.ppm=out.ppm-(4.65-centreFreq);

%Fill in structure header fields:
out.seq='onepulse';
out.te=0;
out.sim='ideal';

%Additional fields for compatibility with FID-A processing tools.
out.sz=size(out.specs);
out.date=date;
out.dims.t=1;
out.dims.coils=0;
out.dims.averages=0;
out.dims.subSpecs=0;
out.averages=1;
out.rawAverages=1;
out.subspecs=1;
out.rawSubspecs=1;
out.flags.writtentostruct=1;
out.flags.gotparams=1;
out.flags.leftshifted=0;
out.flags.filtered=0;
out.flags.zeropadded=0;
out.flags.freqcorrected=0;
out.flags.phasecorrected=0;
out.flags.averaged=1;
out.flags.addedrcvrs=1;
out.flags.subtracted=1;
out.flags.writtentotext=0;
out.flags.downsampled=0;
out.flags.avgNormalized=1;
out.flags.isISIS=0;


