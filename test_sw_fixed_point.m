%
% gainexp>1.0, sharpen.
% gainexp>0.5, spontaneous pattern genaration, otherwise not. Closer to 0.5, takes longer time to reach the stable pattern.
% gainexp=0.5, pattern maintain.
% gainexp<0.5, pattern maintain if fv small, otherwise become flat.
%              the smaller gainexp, the fatter pattern, and requires smaller fv.

% for gainexp=1
%   The fixed point itself is not stable.

include_special_functions;

N = 1000;
K = round2(0.25 * N);

% load network
W_line = circshift([ones(1,K+1), zeros(1,N-K-1)], [0, -floor(K/2)]);
W_line(1) = 0;

W = N * toeplitz(W_line) / N;

%idw = true(1,281);
%idw(1:151) = false;
%w4 = w3(idw, idw);
%W = 1*((w4 + w4') > 0);
%N = length(W);
%K = mean(sum(W,2));

figure(1);
imagesc(W);
colorbar

%% Case: Only inhibitory population.

% Parameters
NI = N;
JI = 20/K;
fv = 20.0e-1;
%fv = 19.0;
fv = 20;
tau = 1.0;

W = -JI * W;

% note: Q(x) = - JI * NI * WII(x)
WII = W_line' / N;
Q   = -JI * NI * WII;

figure(1234719)
%ffteig = real(fft(Q));
%plot(ffteig, '-o');
%ylim([-1 1]*max(ffteig));
%xlim([0 30])
[evec, evalue] = eig(W);
evalue = diag(evalue);
[~, idev] = max(real(evalue));
plot(real(evalue), '-o')

figure(1234721)
plot(evec(:, idev));
title(sprintf('%.3e', evalue(idev)));

% parameters for simulation
delta_t = 0.1;
n_iter = 200 / delta_t;
mu = zeros(N, n_iter);
r  = zeros(N, n_iter);

% select inital value
switch 1
  case 1
    rand('state', 2134')
    r(:, 1) = 0.3*rand(N, 1) + 1.0;
  case 2
    r(:, 1) = r_end;
  case 3
    fq_guess = 6;
    am_guess = 3.7;
    r(:, 1) = am_guess * relu(sin(2*pi*fq_guess*(0:NI-1)/NI));
  case 4
    %fq_guess = 14;
    fq_guess = 6;
    mean_guess = fv / (1 - sum(Q));
    r(:, 1) = 0.1 * sin(2*pi*fq_guess*(0:NI-1)/NI) + mean_guess;
end

% Iteration
gainexp = 1.0;
for j = 1 : n_iter - 1
  %mu(:,j)  = circconv(Q, r(:,j)) + fv;
  mu(:,j)  = W * r(:,j) + fv;
  r(:,j+1) = r(:,j) + delta_t/tau * (-r(:,j) + relu(mu(:,j)).^gainexp);
  %r(:,j+1) = r(:,j) + delta_t/tau * (-r(:,j) + (mu(:,j)).^gainexp);
end
mu(:,end)  = W * r(:,end) + fv;
%mu(:,end)  = circconv(Q, r(:,end)) + fv;

r_end = r(:, end);

figure(122);
imagesc(r);
colormap(inferno());
h=colorbar;
ylabel(h, 'r')

figure(123);
imagesc(mu);
colormap(inferno());
h=colorbar;
ylabel(h, 'mu');

figure(124);
plot(r(:, end));
ylabel('r');
xlabel('x');

figure(126);
plot(min(r));
ylabel('min r');
xlabel('t');

figure(127);
plot(min(mu));
ylabel('min mu');
xlabel('t');

figure(21341);
plot(evec(:,idev), r(:,end), '.');

plotcus1 = @(x,y) plot(x, y, '-o');

figure(21342);
idr = 1:length(W);
[ax, h1, h2] = plotyy(idr,  -evec(:, idev), idr, r(:, end), plotcus1);
ylim(ax(1), [0, 0.3])

return
x = (0:NI-1)/NI;
figure(12341);
for j = 1 : n_iter
  plot(x, r(:, j), x, mu(:, j));
  xlabel('x');
  ylabel('r, mu');
  print('-dpng', sprintf('pic_act/activity_%0.4d.png', j));
end



