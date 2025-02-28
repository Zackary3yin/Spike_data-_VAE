function [sig_out, sig_out_chan] = Cepstrum_MA(eeg)
% eeg_chan = struct('channel',[], 'feat', [],'org_set', []);
% channels = size(eeg,1);

% % %loop through channels
% % for j=1:channels
% %     x = eeg(j,:)';
% %     ceps_out = rceps(x);
% %     
% %     
% % %     a = step(hac, x);
% % %     
% % %     % Run levinson solver to find LPC coefficeints.
% % %     hlevinson = dsp.LevinsonSolver;
% % %     hlevinson.AOutputPort = true;   % Output polynomial coefficients
% % %     LPC = step(hlevinson, a);       % Compute LPC coefficients
% % %     
% % %     %Now convert to cepstral coefficents.
% % %     hlpc2cc = dsp.LPCToCepstral('CepstrumLength',round(1.5*num_lcp));
% % %     
% % %     CC{j} = step(hlpc2cc, LPC); % Convert LPC to CC.
% %     
% %     eeg_chan(j).Cepstrum = mean(ceps_out);
% % 
% % end

ceps_outb = rceps(eeg');



sig_out_chan = mean(ceps_outb,1);
sig_out = mean(sig_out_chan);

end
