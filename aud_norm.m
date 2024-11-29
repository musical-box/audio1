function y = aud_norm(y, trim_sil)

trim_silence = @(s) s(find(abs(s) >= 5e-2, 1, 'first'):find(abs(s) >= 5e-3, 1, 'last'));

size_y = size(y);
if (size_y(2) == 2)
    % the track is stereo, make it mono
    y = 0.5*(y(:,1) + y(:,2));
end

% row vector
y = y(1:end)';

y = y / rms(y);
y = y / max(abs(y));

if exist('trim_sil', 'var')
    if trim_sil
        y = trim_silence(y);
    end
end

end