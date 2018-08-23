%

addpath('/home/xyy/code/point-neuron-network-simulator/mfile');

data_sw = load('sw_3dim.mat');
W = data_sw.W;
n1 = data_sw.n1;
n2 = data_sw.n2;
n3 = data_sw.n3;

pm = [];
pm.neuron_model = 'IF-jump';
pm.simu_method = 'auto';
fprintf('rewiring...'); tic; pm.net  = SmallWorldProbRewire([W,W;W,W]); toc; disp('done');
pm.nI   = length(W);

pm.scee_mV = 0.5;
pm.scie_mV = 0.5;
pm.scei_mV = 1.0;
pm.scii_mV = 1.0;
pm.pr      = 8.0;
pm.ps_mV   = 0.5;

pm.t    = 1e3;
pm.stv  = 10;
pm.dt   = pm.stv;
pm.seed = 'auto';
pm.extra_cmd = '-v --verbose-echo --t-warming-up 1000';

[~, ISI, ras] = gen_neu(pm, '');

% Save firing rate
t_len = 400;
rr = ras(ras(:,2)>t_after, 1);
cnt = histc(rr, 1:length(pm.net))/(t_len/1000);
pm0 = rmfield(pm, 'net');
save('ISI_sw_3d_ei.mat', 'ISI', 'cnt', 'n1', 'n2', 'n3', 'pm0')

