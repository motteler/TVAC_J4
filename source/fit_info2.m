%
% NAME
%   fit_info -- return met laser residuals
%
% SYNOPSIS
%   function wmin = fit_info(band, wlaser, waxis, drms, fmsc);
%
% INPUTS
%   band   - 'LW', 'MW', or 'SW'
%   wlaser - met laser wavelength
%   waxis  - metrology laser search grid, m x 1
%   drms   - rms(obs-calc), m x 9
%   fmsc   - fit_tran internals
%
% OUTPUT
%   wmin   - met laser residuals, 1 x 9
%

function wmin = fit_info(band, wlaser, waxis, drms, fmsc)

% unpack fmsc
wa = fmsc.wa;        % "a" weights, 9 x 1
wb = fmsc.wb;        % "b" weights, 9 x 1
dmin = fmsc.dmin;    % best wlaser fit residuals, 9 x 1
wfov = fmsc.wfov;    % best wlaser fit wlaser values, 9 x 1

% wlaser residuals
[tmin, imin] = min(drms);
wppm = 1e6* (waxis - wlaser) ./ wlaser;
wmin = wppm(imin);

