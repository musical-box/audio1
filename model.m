clear all;
close all;
clc;

% Helper function
global trim_silence;
trim_silence = @(s) s(find(abs(s) >= 5e-2, 1, 'first'):find(abs(s) >= 5e-3, 1, 'last'));

% Model constants
global fs;
fs = 16000;
global dt;
dt = 1 / fs;
global ioi_ms;
ioi_ms = 8;
global min_ns;
min_ns = floor(2 / (dt*1e3));
global max_ns;
max_ns = floor(ioi_ms * 2 / (dt*1e3));
global use_bp;
use_bp = 1;
global xcorr_non_refl_ms;
xcorr_non_refl_ms = 0.5;
global max_h_score;
max_h_score = 10;
global hist_threshold;
hist_threshold = 0.1;
global hist_edges;
hist_edges = floor(ioi_ms + 1);

%% Hyperparameter optimisation experiment

% Hyperparameters of choice
global delta_neigh;
global num_xcorr_ints;
global fp_opts;

params = readtable('params.txt', 'ReadVariableNames', false);
params = params.Variables;

delta = params(1);
xcorr_int = params(2);
mpp = params(3);

delta_neigh = delta;
num_xcorr_ints = xcorr_int;
fp_opts = {'MinPeakProminence', mpp, 'MaxPeakWidth', floor(2 / (dt * 1e3)), 'Annotate', 'extents'};

input_dir = readlines('dataset.txt');

run_analysis(input_dir);

%% Model

function [p_locs, p_proms] = calc_xcorr(yf, delay, xcorr_delta)

global dt;
global fp_opts;
global xcorr_non_refl_ms;

corr_num_s = delay;

corr_bins = zeros(corr_num_s, delay);

num_s = delay;
[autocorr, lags] = xcorr(yf(1:num_s), 'coeff');
autocorr = autocorr(lags >= 0);
corr_bins(1:num_s, delay) = autocorr(:);
corr_vals = corr_bins(1:num_s, delay);

corr_vals(1:round(xcorr_non_refl_ms / (dt * 1e3))) = 0;

if xcorr_delta
    corr_vals = delta_signal(corr_vals);
else
    corr_vals = abs(corr_vals);
end

[~, p_locs, ~, p_proms] = findpeaks(corr_vals, fp_opts{:});

end

function hist_values = calc_xcorrs(yf, min_delay, max_delay, num_ints, ...
    xcorr_delta)

delays = round(linspace(min_delay, max_delay, num_ints));

p_locs = [];
p_proms = [];

plot_num = 1;
for i=1:1:length(delays)
    delay = delays(i);
    [locs, proms] = calc_xcorr(yf, delay, xcorr_delta);
    if ~isempty(locs)
        p_locs = [p_locs make_row_v(locs)];
    end
    if ~isempty(proms)
        p_proms = [p_proms make_row_v(proms)];
    end
    plot_num = plot_num + 1;
end

[~, hist_values] = weighted_hist(p_locs, p_proms);

end

function deltas = delta_signal(sig_vals)

global delta_neigh;

if (size(sig_vals, 1) > size(sig_vals, 2))
    sig_vals = sig_vals';
end

deltas = cat(2, sig_vals, zeros(1, delta_neigh)) - ...
    cat(2, zeros(1, delta_neigh), sig_vals);
deltas = abs(deltas(1:end-delta_neigh));

end

function [y, fs_ssample] = load_wav(file_path, ssample)

global fs;

[y, Fs] = audioread(file_path);
y = aud_norm(y);

if (Fs ~= fs)
    y = aud_resample(y, fs, Fs);
end

if exist('ssample', 'var')
    fs_ssample = round(fs/Fs*ssample);
end

end

function [edges, values] = weighted_hist(p_locs, p_proms)

global ioi_ms;
global dt;
global hist_edges;

edges = linspace(1, floor(ioi_ms / (dt * 1e3)), hist_edges);
[values, ~] = histcounts(p_locs, edges);
wgts = zeros(size(values));
for i = 1:1:length(values)
    locs = (p_locs >= edges(i)) & (p_locs < edges(i+1));
    wgts(i) = sum(p_proms(locs));
end

values = wgts;

if max(values) > 0
    values = values ./ max(values);
end

end

function row_v = make_row_v(v)

if (size(v, 1) > size(v, 2))
    row_v = v';
else
    row_v = v;
end

end

function run_analysis(input_dir)

global min_ns;
global max_ns;
global fs;
global use_bp;
global num_xcorr_ints;

fc_low = 200;
fc_hi = 6500;

fir_ord = 128;

if use_bp && (fc_hi < (fs/2))
    bp_filter = fir1(fir_ord, [fc_low/(fs/2) fc_hi/(fs/2)], chebwin(fir_ord+1,90));
end

files = dir(fullfile(input_dir, '*.wav'));

for i = 1:length(files)

    yf = load_wav(fullfile(input_dir, files(i).name));
    
    if use_bp && (fc_hi < (fs/2))
        yf = filter(bp_filter, 1, yf);
    end
    
    xcorr_hist = calc_xcorrs(yf, min_ns, max_ns, num_xcorr_ints, ...
        true);

    writelines(num2str(xcorr_hist, '%5.2f'), fullfile(input_dir, strrep(files(i).name, '.wav', '_predicted.txt')));

end

end

