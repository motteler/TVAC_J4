%
% met laser residual summary
% loads fit_run from each test
%

d1 = load('11-08_pl_s2_CO2/fit_run');
d2 = load('11-11_pl_s1_CO2/fit_run');
d3 = load('11-11_pl_s1_CO2_d1/fit_run');
d4 = load('11-11_pl_s1_CH4/fit_run');
d5 = load('11-10_pl_s1_CO/fit_run');

fprintf('                        ')
fprintf('metrology laser absolute residuals by FOV\n')
fprintf('   Test       ');
fprintf('%7.0f', 1:9); fprintf('\n');

fprintf('11-08 s2 d0 CO2 ');
wmin1 = fit_info2(d1.band, d1.wlaser, d1.waxis, d1.drms, d1.fmsc);
fprintf('%7.2f', wmin1); fprintf('\n');

fprintf('11-11 s1 d0 CO2 ');
wmin2 = fit_info2(d2.band, d2.wlaser, d2.waxis, d2.drms, d2.fmsc);
fprintf('%7.2f', wmin2); fprintf('\n');

fprintf('11-11 s1 d1 CO2 ');
wmin3 = fit_info2(d3.band, d3.wlaser, d3.waxis, d3.drms, d3.fmsc);
fprintf('%7.2f', wmin3); fprintf('\n');

fprintf('11-11 s1 d0 CH4 ');
wmin4 = fit_info2(d4.band, d4.wlaser, d4.waxis, d4.drms, d4.fmsc);
fprintf('%7.2f', wmin4); fprintf('\n');

fprintf('11-10 s1 d0 CO  '); 
wmin5 = fit_info2(d5.band, d5.wlaser, d5.waxis, d5.drms, d5.fmsc);
fprintf('%7.2f', wmin5); fprintf('\n');

fprintf('\n\n')
fprintf('                        ')
fprintf('metrology laser relative residuals by FOV\n')
fprintf('   Test       ');
fprintf('%7.0f', 1:9); fprintf('\n');

fprintf('11-08 s2 d0 CO2 ');
fprintf('%7.2f', wmin1-wmin1(5)); fprintf('\n');

fprintf('11-11 s1 d0 CO2 ');
fprintf('%7.2f', wmin2-wmin2(5)); fprintf('\n');

fprintf('11-11 s1 d1 CO2 ');
fprintf('%7.2f', wmin3-wmin3(5)); fprintf('\n');

fprintf('11-11 s1 d0 CH4 ');
fprintf('%7.2f', wmin4-wmin4(5)); fprintf('\n');

fprintf('11-10 s1 d0 CO  '); 
fprintf('%7.2f', wmin5-wmin5(5)); fprintf('\n');

fprintf('\n\n')
fprintf('11-08 s2 CO2 wlaser=%.5f neon=%.5f\n', d1.wlaser, d1.opt2.neonWL);
fprintf('11-11 s1 CO2 wlaser=%.5f neon=%.5f\n', d2.wlaser, d2.opt2.neonWL);
fprintf('11-11 s1 CH4 wlaser=%.5f neon=%.5f\n', d4.wlaser, d4.opt2.neonWL);
fprintf('11-10 s1 CO  wlaser=%.5f neon=%.5f\n', d5.wlaser, d5.opt2.neonWL);
fprintf('\n')
