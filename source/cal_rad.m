%
% NAME
%   cal_rad - calibrated radiances from TVAC packet stream
%
% SYNOPSIS
%   function [robs, vobs] = cal_rad(band, wlaser, tleg, eset, opts);
%
% INPUTS
%   band    - 'LW', 'MW', or 'SW'
%   wlaser  - metrology laser half-wavelength
%   tleg    - data from ET1, ET2, FT1, or FT2
%   eset    - desired subset of ES looks
%   opts    - any remaining run parameters
%
% OUTPUTS
%   robs   - calibrated radiances 
%   vobs   - associated frequencies
%
% DISCUSSION
%   cal_rad breaks out the ES, SP, and IT looks from tleg and uses
%   this info to produce calibrated ES radiances.  tleg is one of the
%   4 test legs, ET1, ET2, FT1, or FT2.  These are packet sequences
%   from the TVAC tests, translated by Dan's reader to matlab structs.
%   eset is a matlab index for the subset of the ES look that contains
%   valid data.  The IT and SP looks do not need this subsetting.
%

function [robs, vobs] = cal_rad(band, wlaser, tleg, eset, opts);

% params from opts
sdir = opts.sdir;
sfile = opts.sfile;

% get instrument params
opt1 = struct; 
opt1.user_res = 'hires';
opt1.inst_res = 'hires4';
[inst, user] = inst_params(band, wlaser, opt1);

% break out the igm data
[igm_es, igm_sp, igm_it] = igm_breakout(band, tleg, sdir);

% translate to count spectra
spec_es = igm2spec(igm_es, inst);
spec_sp = igm2spec(igm_sp, inst);
spec_it = igm2spec(igm_it, inst);

% take the ES subset.
spec_es = spec_es(:, :, eset);
% time_es = time_es(:, eset);

% take the ES, IT, and SP means
mean_es = mean(spec_es, 3);
mean_sp = mean(spec_sp, 3);
mean_it = mean(spec_it, 3);

% take the basic calibration ratio
robs = (mean_es - mean_sp) ./ (mean_it - mean_sp);
robs = bandpass(inst.freq, robs, user.v1, user.v2, user.vr);

% get the SA inverse matrix
switch band
  case 'LW', opt1.LW_sfile = sfile;
  case 'MW', opt1.MW_sfile = sfile;
  case 'SW', opt1.SW_sfile = sfile;
  otherwise, error(['bad band spec ', band]);
end
Sinv = getSAinv(inst, opt1);

% apply the SA inverse matrix
for i = 1 : 9
  robs(:, i) = Sinv(:,:,i) * robs(:, i);
end
robs = bandpass(inst.freq, robs, user.v1, user.v2, user.vr);

% get expected ICT radiance
nsci = ztail(tleg.data.sci.Temp.time);
ict_temps = ICT_countsToK(tleg.data.sci.Temp, tleg.packet.TempCoeffs, nsci);
tICT = mean([ict_temps.T_PRT1, ict_temps.T_PRT2]);
rICT = bt2rad(inst.freq, tICT);

% multiply by expected radiance
for i = 1 : 9
  robs(:, i) = rICT .* robs(:, i);
end

% get vobs from inst params
vobs = inst.freq;

