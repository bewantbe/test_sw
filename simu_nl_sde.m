%
heaviside = @(x) (sign(x)+1)/2;

N = 400;
K = 40;

%W_line = circshift([ones(1,K+1), zeros(1,N-K-1)], -floor(K/2));
%W_line(1) = 0;
%W = toeplitz(W_line);
load('sw_2dim.mat')

N = 10000;
J = -0.16;

I0 = 100;
%tau_noise = 5e-2;
%I_xi = 7 / sqrt(tau_noise);
tau_noise = 2e-1;
I_xi = 100 / sqrt(tau_noise);

T = 10;     % sec
dt = 1e-3;

n_dt = floor(T/dt);
T = n_dt * dt;

r = rand(N,1);
I_noise = zeros(N,1);
%rec_r = zeros(N, n_dt);

tid=tic;
for id_dt = 1:n_dt
%  xi = I_xi * sqrt(r) / sqrt(dt) .* randn(N,1);
%  I_noise = I_noise + dt * (-I_noise / tau_noise - W * xi * J);
  xi = I_xi / sqrt(dt) .* randn(N,1);
  I_noise = I_noise + dt * (-I_noise / tau_noise - xi * J);
  I = W * r * J + I_noise + I0;
  r = r + dt * (-r + I .* heaviside(I));
  fprintf('step = %d / %d\n', id_dt, n_dt);
%  rec_r(:, id_dt) = r;
end
toc(tid)

%figure(6);
%plot(-1 + J * real(fft(W_line)));
%title('eigen value');

%figure(10);
%plot(rec_r(1, :));

figure(11);
plot(I_noise);
fprintf('Noise std %.3g\n', std(I_noise))

figure(12);
plot(r, '-o');

%figure(14);
%imagesc(rec_r);
%colorbar();

%figure(14);
%imagesc([0 T], [0 N], rec_r > max(rec_r(:))/2);
%colorbar();

%ylim([200 250])

figure(112);
imagesc(reshape(r, [n1, n2]))
colorbar()

print('-deps', 'rate_2dim.eps')

