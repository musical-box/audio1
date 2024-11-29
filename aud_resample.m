function ir = aud_resample(ir, fs, fs_ir)

% fs - desired fs
% fs_ir - current fs

% resample if needed
% https://uk.mathworks.com/help/signal/ug/resampling.html
[p, q] = rat(fs/fs_ir, 1e-6);
ir = resample(ir, p, q);

end