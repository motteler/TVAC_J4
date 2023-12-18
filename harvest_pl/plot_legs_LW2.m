%
% plot LW test legs, uses data from read_ccs
%
% T1 > T2
%

addpath ../source
d02 = load('ccs_data_11_08');
dbase2 = datenum('8 Nov 2023');

% ET1, nominal 350K, cell empty
t1 = hhmmss_to_hour('09:03:33');
t2 = hhmmss_to_hour('09:23:27');
plot_leg(d02, dbase2, t1, t2, 'LW ET1', 1);
subplot(3,1,1);  % ylim([349.9, 350.05])
% saveas(gcf, '11-08_LW_ET1', 'fig')

% ET2 nominal 320K, cell empty
t1 = hhmmss_to_hour('01:54:35');
t2 = hhmmss_to_hour('02:12:06');
plot_leg(d02, dbase2, t1, t2, 'LW ET2', 2);
subplot(3,1,1);  % ylim([319.8, 320.1])
% saveas(gcf, '11-08_LW_ET2', 'fig')

% FT2, nominal 320K, 50 Torr, 13.5 C
t1 = hhmmss_to_hour('03:12:36');
t2 = hhmmss_to_hour('03:28:28');
plot_leg(d02, dbase2, t1, t2, 'LW FT2', 3);
subplot(3,1,1);  % ylim([319.8, 320.1])
% saveas(gcf, '11-08_LW_FT2', 'fig')

% FT1 nominal 350, 50 Torr, 13.6 C
t1 = hhmmss_to_hour('05:58:34');
t2 = hhmmss_to_hour('06:14:48');
plot_leg(d02, dbase2, t1, t2, 'LW FT1', 4);
subplot(3,1,1);  % ylim([349.9, 350.05])
subplot(3,1,2);  % ylim([49.64, 49.67]) 
% saveas(gcf, '11-08_LW_FT1', 'fig')

