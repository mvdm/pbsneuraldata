%% setup
% clone https://github.com/manimoh/fieldtrip.git and
% https://github.com/vandermeerlab/mm_phase_stim

restoredefaultpath; clear; %start with a clean slate
p2 = genpath('C:\Users\mattm\Documents\GitHub\mm_phase_stim\code-matlab\shared');
p3 = genpath('C:\Users\mattm\Documents\GitHub\mm_phase_stim\code-matlab\ec_code');
p4 = genpath('C:\Users\mattm\Documents\GitHub\mm_phase_stim\code-matlab\mm_util');
p5 = 'C:\Users\mattm\Documents\GitHub\fieldtrip';
p6 = genpath('C:\Users\mattm\Documents\GitHub\fieldtrip\fileio\');
p7 = genpath('C:\Users\mattm\Documents\GitHub\fieldtrip\utilities');
p8 = genpath('C:\Users\mattm\Documents\GitHub\fieldtrip\contrib\spike');
p9 = genpath('C:\Users\mattm\Documents\GitHub\fieldtrip\specest');
p10 = genpath('C:\Users\mattm\Documents\GitHub\fieldtrip\preproc');
p11 = genpath('C:\Users\mattm\Documents\GitHub\fieldtrip\external\brainstorm');  

addpath(p2);
addpath(p3);
addpath(p4);
addpath(p5);
addpath(p6);
addpath(p7);
addpath(p8);
addpath(p9);
addpath(p10);
addpath(p11);

clear;

% Set Axes Font Size default to avoid annoying mvdm
set(groot, 'defaultAxesFontSize', 18);

%% load a LFP
cd('C:\data\R016-2012-10-08');
LoadExpKeys;
cfg.fc = ExpKeys.goodGamma(1);
this_lfp = LoadCSC(cfg);


%%
Fs = this_lfp.cfg.hdr{1}.SamplingFrequency;
wsize = Fs;
[P_Og, F] = pwelch(this_lfp.data, hanning(wsize), wsize/2, [], Fs);
% [P_filt,~] = pwelch(filtered_lfp.data, hanning(wsize), wsize/2, [], Fs);
figure;
hold on;
plot(F, 10*log10(P_Og), 'LineWidth', 2);
xlim([0 120]); grid on;
xlabel('Frequency (Hz)'); ylabel('Power (dB)');

%%
F = (F(F > 0 & F < 120))'; % very important to get rid of the '0' frequency for FOOOF to work, and shape it into 1 x N array
P_Og = (P_Og(1:length(F)))';
reshaped_P = reshape(P_Og,1 ,1, length(P_Og));
% All these parameters are borrowed from "process_fooof.m"
opt.freq_range = [F(1) F(end)];
opt.power_line = '60';
opt.peak_width_limits = [0.5,12];
opt.max_peaks = 3;
opt.min_peak_height = 0.3;
opt.aperiodic_mode = 'knee'; %Check with 'fixed' first
opt.peak_threshold = 2;
opt.return_spectrum = 1;
opt.border_threshold = 1;
opt.peak_type = 'best'; %There is an error in documenation where it says 'both'
opt.proximity_threshold = 2;
opt.guess_weight = 'none';
opt.thresh_after = 1;
opt.sort_type = 'param';
opt.sort_param = 'frequency';
%     opt.sort_bands = {{'delta'}, {'2', '4'}; {'theta'}, {'5', '7'}; ...
%         {'alpha'}, {'8','12'}; {'beta'}, {'15', '29'}; {'gamma1'}, {'30',' 59'};
%         {'gamma2'}, {'60','90'}};
opt.sort_bands = {{'delta'}, {'2', '5'}; {'theta'}, {'6', '10'}; ...
    {'beta'},{'15', '29'}; {'gamma1'}, {'30',' 55'}; ...
    {'gamma2'}, {'65','90'}};
[fs, fg] = process_fooof('FOOOF_matlab', reshaped_P, F, opt, 1);
powspctrm_f = cat(1, fg.ap_fit);
for k = 1:size(powspctrm_f,1)
    aperiodic_P(k,:) = interp1(fs, powspctrm_f(k,:), F, 'linear', nan);
end
figure;
plot(F, 10*log10(P_Og))
hold on;
plot(F, 10*log10(aperiodic_P))
for iR = 1:size(fg.peak_params,1)
    xline(fg.peak_params(iR,1), 'black');
end