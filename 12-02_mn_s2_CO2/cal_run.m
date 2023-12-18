%
% cal_run -- set up params, call cal_fit, plot results
%
% edit as needed for each test
%
% set for the SW 1 Jun PFH CO test, with the big ripple
%

%----------------
% paths and libs
%----------------

addpath /home/motteler/cris/ccast/source
addpath /home/motteler/cris/ccast/davet
addpath /home/motteler/cris/ccast/motmsc/utils
addpath /home/motteler/shome/airs_decon/test
addpath ../source
addpath ../gas_calcs

%----------------
% run parameters
%----------------
opts = struct;    % all opts in 1 struct
test_dir = '.';   % location of test data
band = 'LW';      % set the band

% run name for plots
pname = 'CO2, 2 Dec 2023 MN side 2';

% get true wlaser from FT2 eng and Neon
opts.neonWL = 703.44765;   % Larrabee's value
load(fullfile(test_dir, 'FT2'));
[wlaser, wtime] = metlaser(d1.packet.NeonCal, opts);

eng_neon = d1.packet.NeonCal.NeonGasWavelength;
fprintf(1, 'eng neon=%.5f assigned neon=%.5f, wlaser=%.5f\n', ... 
  eng_neon, opts.neonWL, wlaser);
clear d1

% set the search grid
% wgrid = -0.025 : .0005 : 0.035;
  wgrid =  -0.01 : .0002 : 0.02;
waxis = wlaser + wgrid;

% options for inst_params
opts.user_res = 'hires';
opts.inst_res = 'hires4';

% set the fitting interval
opts.qv1   = 672;  % start
opts.qv2   = 712;  % end

% calc parameters
opts.abswt = 12.69;
% opts.gfile = '../gas_calcs/lblr_CO2_49p75_Torr_17p27_C';
  opts.gfile = '../gas_calcs/lblr_CO2_49p65_Torr_15p70_C';
opts.gc = load(opts.gfile);

% obs parameters
opts.sdir = 0;
opts.sfile = '../inst_data/SAinv_default_HR4_LW';

% specify the ES subsets
% values are for the 06-02_mn_s2_CO2 test
igm  = struct;
igm.et1_ix = 206:536;
igm.et2_ix = 395:720;
igm.ft2_ix = 488:815;
igm.ft1_ix = 272:599;

% load the test legs
load(fullfile(test_dir, 'ET1')); igm.et1 = d1;
load(fullfile(test_dir, 'ET2')); igm.et2 = d1;
load(fullfile(test_dir, 'FT2')); igm.ft2 = d1;
load(fullfile(test_dir, 'FT1')); igm.ft1 = d1;
clear d1;

%-------------
% call cal_fit
%-------------

[drms, fmsc] = cal_fit(band, waxis, igm, opts);

fit_info(band, wlaser, waxis, drms, fmsc)

% -----------------------------------
% plot fitting errors by wlaser shift
% -----------------------------------

figure(1); clf;
set(gcf, 'DefaultAxesColorOrder', fovcolors);
plot(waxis, drms, 'linewidth', 2)
xlim([round2n(waxis(1), 5), round2n(waxis(end), 5)])
xlabel('wavelength, nm')
ylabel('rms fitting error')
title(sprintf('%s, residual as a function of wlaser', pname));
legend(fovnames, 'location', 'north')
grid on; zoom on
saveas(gcf, 'CO2_cal_wlaser_fit', 'fig')

%-----------------------------------
% plot residuals with FOV breakouts
%-----------------------------------

freq3M = fmsc.freq3M;
tcal3M = fmsc.tcal3M;
tobs4M = fmsc.tobs4M;

fname = fovnames;
fcolor = fovcolors;

figure(2); clf
set(gcf, 'DefaultAxesColorOrder', fcolor);

subplot(2,1,1)
plot(freq3M{1}, tobs4M{1} - tcal3M{1}, ...
     freq3M{2}, tobs4M{2} - tcal3M{2}, ...
     freq3M{3}, tobs4M{3} - tcal3M{3}, ...
     freq3M{4}, tobs4M{4} - tcal3M{4}, ...
     freq3M{5}, tobs4M{5} - tcal3M{5}, ...
     freq3M{6}, tobs4M{6} - tcal3M{6}, ...
     freq3M{7}, tobs4M{7} - tcal3M{7}, ...
     freq3M{8}, tobs4M{8} - tcal3M{8}, ...
     freq3M{9}, tobs4M{9} - tcal3M{9})
axis([opts.qv1, opts.qv2, -.02, .02])
xlabel('wavenumber')
ylabel('transmittance difference')
title('obs minus calc all FOVs')
% legend(fname, 'location', 'southeast')
grid on; zoom on

subplot(2,1,2)
ix = 5;
set(gcf, 'DefaultAxesColorOrder', fcolor(ix,:));
plot(freq3M{5}, tobs4M{5} - tcal3M{5})
axis([opts.qv1, opts.qv2, -.02, .02])
xlabel('wavenumber')
ylabel('transmittance difference')
title('obs minus calc FOV 5')
legend(fname{ix}, 'location', 'southeast')
grid on; zoom on
saveas(gcf, 'CO_cal_breakout_1', 'fig')

figure(3); clf
set(gcf, 'DefaultAxesColorOrder', fcolor);

subplot(2,1,1)
ix = [2 4 6 8];
set(gcf, 'DefaultAxesColorOrder', fcolor(ix,:));
plot(freq3M{2}, tobs4M{2} - tcal3M{2}, ...
     freq3M{4}, tobs4M{4} - tcal3M{4}, ...
     freq3M{6}, tobs4M{6} - tcal3M{6}, ...
     freq3M{8}, tobs4M{8} - tcal3M{8});
axis([opts.qv1, opts.qv2, -.02, .02])
xlabel('wavenumber')
ylabel('transmittance difference')
title('obs minus calc side FOVs')
legend(fname{ix}, 'location', 'southeast')
grid on; zoom on

subplot(2,1,2)
ix = [1 3 7 9];
set(gcf, 'DefaultAxesColorOrder', fcolor(ix,:));
plot(freq3M{1}, tobs4M{1} - tcal3M{1}, ...
     freq3M{3}, tobs4M{3} - tcal3M{3}, ...
     freq3M{7}, tobs4M{7} - tcal3M{7}, ...
     freq3M{9}, tobs4M{9} - tcal3M{9})
axis([opts.qv1, opts.qv2, -.02, .02])
xlabel('wavenumber')
ylabel('transmittance difference')
title('obs minus calc corner FOVs')
legend(fname{ix}, 'location', 'southeast')
grid on; zoom on
saveas(gcf, 'CO_cal_breakout_2', 'fig')

