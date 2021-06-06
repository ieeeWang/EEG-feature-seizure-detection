function [temp, freq] = extractBandFFT2008 ( obj, epochEEG, settings, p1, p2)
% extractBandFFT performs bandpass filtering with optionally transformations
% 
% Algorithm:
%   1) (optionally) windowing
%   2) Substract a subband using FFT filtering: min(band) <= f < max(band).
%   3) (optionally) making analytical signal
%   4) IFFT
%   5) (optionally) unwindowing 
%   
% Inputs:
%   epochEEG - EEG epoch to analyse [channels, samples]
%   band - [lowBand, highBand], highBand<=fs/2
%   fs - sampling frequencie
%   flags:
%       'hamm' - activate hamming windowing
%       'analit' - perform Hilbert transform and cosntract the analitical signal
% Outputs:
%   temp - time domain representation of the result [channels, samples, subbandindex] 
%   freq - freqency domain "---"
%
% Remarks:  (1) The length in seconds of the epoch is critical due to frequency resolution; 
%           (2) The number of samples must be even 
%
%   *************************************************************************
%   created     Andrei Sazonov  21.01.04    it is meant to use on multichannel EEGs
%   modifyed    Andrei Sazonov  07.02.04    windowing is added
%   modifyed    Andrei Sazonov  02.03.04    Hilbert transform is added
%   modified    Andrei Sazonov  29.03.04    Double amplitude bug fixed
%                                           input paramiters are also changed
%   modified    Andrei Sazonov  05.04.04    Warnings added
%   modified    Andrei Sazonov  14.10.04    Text output is blocked
%   modified    Andrei Sazonov  24.11.04    Minor changes
%   modified    Andrei Sazonov  27.06.05    Unwindowing is improved :-)
%   modified    Andrei          10.12.05    Mask is optimized
%   modified    Andrei          14.12.05    Complex valued data is treated properly
%   modified    Andrei          06.12.06    Uncomment an extra check for the band
%                               10.02.08    change mask stuff and hilbert power
%                               17.08.08    Optimize the code 
%                               24.08.08    fine tune hilbert 
%   *************************************************************************

band=settings.subbands;
fs=settings.fs;

% check the input parameters
if nargin < 3
    help extractBandFFTm;
    return;
end

wFlag = 0;
hFlag = 0;

for index = nargin:-1:4
    param = eval(['p',int2str((index-3))]);
    switch lower(param)
        case    'hamm'
            wFlag = 1;
        case    'analit'
            hFlag = 1;
        otherwise
    	    error(['Unknown input parameter ''' param ''' ???']);
    end
end
    
if ((size(band,1) < 1) || (size(band,2)~=2) || (min(min(band)) < 0) || (max(max(band)) > fs/2))
    error('Wrong frequency band');
end

% compute signal dimentions
N = size (epochEEG,2);     % epoch length
nCh = size(epochEEG,1);    % numner of channels

% check that the length is even
if mod(N,2) ~= 0
    error ('The epoch length must be even!');
end

% to reduce the leakage 
if wFlag
    W = repmat(hamming(N)', nCh, 1);
    epochEEG = epochEEG.*W;
end

% compute FFT
spectrum = fft(epochEEG,[],2); % FFT of rows 

% compute the actual range of the desired band

df = fs/N;  % frequency resolution
r = round(band/df);  % index in spectrum
freq = zeros(nCh, N, size(band,1));
temp = freq;
for index = 1:size(band,1)

    % check wheather the indicies are meaningfull
    if r(index,1) == r(index,2)
        error('The frequency resolution is lower than the pass band. No filtering is performed.');
    end

    if (r(index,1) == 0) && (band(index,1) > 0)
        disp('The DC component is not supressed due to a low frequency resolution.');
    end

    %% uncomment if you want to see the actual frequency range
    %disp(['The actual filtering range is: ',num2str(r*df),' (df=',num2str(df),'), all in Hz']);

    mask = zeros(1,N);
    mask(r(index,1)+1:r(index,2)+1) = 1;
    mask(N/2+2:N) = mask(N/2:-1:2);
    
    % perform Hilbert transformation or not
    if hFlag
       % mask(1:N/2+1) = mask(1:N/2+1) * 1;
        mask(2:N/2) = mask(2:N/2) * 2;
        mask(N/2+2:N) = 0;
    end
    
    mask = repmat(mask, nCh,1);
    
    % perform the selection of the band
    freq(:,:,index) = spectrum.*mask;

    % perform IFFT to constract the filtered signal in time domain
    temp(:,:,index) = ifft(freq(:,:,index),[],2);
    
    %% unwindowing
   % if wFlag
   %     W = hamming(N)';
   %     warning('windowing for multiple subbands does not work properly, especially for complex numbers');
   %     for ch = 1:nCh
   %         temp(ch,:, index) = temp(ch,:, index)./W;
   %     end
   % end
    
    if ((sum(sum(imag(epochEEG).^2)) == 0) && (hFlag == 0))  %% if the input is real valued ...
        temp(:,:,index) = real(temp(:,:,index));    % ... then make the output real
    end
end

%disp('done');
