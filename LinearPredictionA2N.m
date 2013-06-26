function score = LinearPredictionA2N(fr,trace);
% Function which attempts to predict the astrocyte trace on the basis of
% the network firing rate. Returns a cross-correlation of the prediction
% versus the actual trace at zero-lag. The higher the cross-correlation,
% the more "wired-in" this astrocyte is to the neural network. 
% Revision 1: May 24, 2013
% Written by: Noah Levine-Small
frF=fft(fr);
AF=fft(trace);
rA2fr = AF./frF;
prediction =  conv(fr,ifft(rA2fr));
prediction = prediction(1:length(trace));
score = NormalizedCorrelationNoLag(trace,prediction);

% hold on; plot(fr,'r'); plot(trace,'g'); plot(prediction,'k');hold off;
end