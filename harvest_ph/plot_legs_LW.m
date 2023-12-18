%
% plot LW test legs, uses data from read_ccs
%
% T1 > T2
%

addpath ../source
d02 = load('ccs_data_11_17');
dbase2 = datenum('17 Nov 2023');

% ET1, nominal 355K, cell empty
t1 = hhmmss_to_hour('20:54:09');
t2 = hhmmss_to_hour('21:10:30');
plot_leg(d02, dbase2, t1, t2, 'LW ET1', 1);
subplot(3,1,1);  ylim([354.9, 355.02])
saveas(gcf, '11-17_LW_ET1', 'fig')

% ET2 nominal 320K, cell empty
t1 = hhmmss_to_hour('15:21:22');
t2 = hhmmss_to_hour('15:37:43');
plot_leg(d02, dbase2, t1, t2, 'LW ET2', 2);
subplot(3,1,1);  ylim([319.85, 320.02])
saveas(gcf, '11-17_LW_ET2', 'fig')

% FT2, nominal 320K, 50 Torr, 16 C
t1 = hhmmss_to_hour('12:35:12');
t2 = hhmmss_to_hour('12:50:59');
plot_leg(d02, dbase2, t1, t2, 'LW FT2', 3);
subplot(3,1,1);  ylim([319.85, 320.02])
subplot(3,1,2);  ylim([50, 50.2])
saveas(gcf, '11-17_LW_FT2', 'fig')

% FT1 nominal 355K, 50 Torr, 16 C
t1 = hhmmss_to_hour('22:39:06');
t2 = hhmmss_to_hour('22:54:33');
plot_leg(d02, dbase2, t1, t2, 'LW FT1', 4);
subplot(3,1,1);  ylim([354.9, 355.02])
subplot(3,1,2);  ylim([50, 50.2]) 
saveas(gcf, '11-17_LW_FT1', 'fig')

