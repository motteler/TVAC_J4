%
% check_leg2 -- add ICT and Space looks
%
% main test parameters
%   band    - 'LW', 'MW', or 'SW'
%   wlaser  - metrology laser half-wavelength
%   mfile   - mat file, output from the MIT reader
%   sdir    - sweep direction, 0 or 1
%   ifrq    - frequency index for figure 2
%   ifov    - choose a FOV for figure 3
%
% derived from spec_test1 and plot_legs
%

% paths and libs
addpath /asl/packages/ccast/source
addpath /asl/packages/ccast/motmsc/time
addpath ../source

% select a band
band = upper(input('band (e.g., LW) > ', 's'));

% select a test leg
tleg = upper(input('test leg (e.g., FT2) > ', 's'));
mfile = fullfile('./', tleg);
load(mfile);

% harvest directory
harvest = 'harvest_mn';

% get wlaser from eng and neon
opt2 = struct;
opt2.neonWL = 703.44765;  % Larrabee's value
[wlaser, wtime] = metlaser(d1.packet.NeonCal, opt2);

% get instrument params
opt1 = struct; 
opt1.user_res = 'hires';
opt1.inst_res = 'hires4';
[inst, user] = inst_params(band, wlaser, opt1);

% choose a sweep direction
sdir = 0;

fprintf(1, 'eng neon=%.5f assigned neon=%.5f, wlaser=%.5f\n', ... 
  d1.packet.NeonCal.NeonGasWavelength, opt2.neonWL, wlaser);

% break out the igm data
[igm_es, igm_sp, igm_it, time_es, time_sp, time_it] = ...
         igm_breakout(band, d1, sdir);

% translate to count spectra
spec_es = igm2spec(igm_es, inst);
spec_sp = igm2spec(igm_sp, inst);
spec_it = igm2spec(igm_it, inst);

% get obs times in matlab format
dnum_es = iet2dnum(time_es(5,:));
dtime_es = datetime(dnum_es, 'ConvertFrom', 'datenum');

dnum_sp = iet2dnum(time_sp(5,:));
dtime_sp = datetime(dnum_sp, 'ConvertFrom', 'datenum');

dnum_it = iet2dnum(time_it(5,:));
dtime_it = datetime(dnum_it, 'ConvertFrom', 'datenum');

% harvest start and end times
t1 = dtime_es(1);
t2 = dtime_es(end);

% loop on time adjustments
while 1

  % get the associated ccs data
  fmt = '../%s/ccs_data_%02d_%02d';
  d2 = load(sprintf(fmt, harvest, t1.Month, t1.Day));
  
  % show all FOVs at one frequency
  figure(1); clf
  ifrq = floor(inst.npts/2);
  vseq_es = abs(squeeze(spec_es(ifrq, :, :)));
  vseq_it = abs(squeeze(spec_it(ifrq, :, :)));
  vseq_sp = abs(squeeze(spec_sp(ifrq, :, :)));
  plot(dtime_es, vseq_es, 'r.'); hold on
  plot(dtime_sp, vseq_sp, 'g.'); 
  plot(dtime_it, vseq_it, 'b.');
  xlim([t1, t2])
  title(sprintf('test %s, all FOVs at %.2f cm-1', tleg, inst.freq(ifrq)))
  % legend('ES', 'SP', 'IT')
  xlabel('time')
  ylabel('count')
  grid on; zoom on
  
  % show all obs for one FOV
  figure(2); clf
  ifov = 5;
  plot(inst.freq, squeeze(abs(spec_sp(:, ifov, :))), 'b');
  title(sprintf('SP test %s, FOV %d all obs', tleg, ifov))
  xlabel('wavenumber')
  ylabel('count')
  grid on; zoom on
  
  figure(3); clf
  ifov = 5;
  plot(inst.freq, squeeze(abs(spec_it(:, ifov, :))), 'b');
  title(sprintf('IT test %s, FOV %d all obs', tleg, ifov))
  xlabel('wavenumber')
  ylabel('count')
  grid on; zoom on

  % current time span
  fprintf(1, 't1 = %s\n', t1)
  fprintf(1, 't2 = %s\n', t2)

  if input('OK? (y/n) > ', 's') == 'y', break, end

  % update time interval
  tx = input('t1 (hh:mm:ss) > ', 's');
  [~,~,~, t1.Hour, t1.Minute, t1.Second] = datevec(tx);

  tx = input('t2 (hh:mm:ss) > ', 's');
  [~,~,~, t2.Hour, t2.Minute, t2.Second] = datevec(tx);

end
