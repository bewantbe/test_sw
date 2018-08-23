%

N = 40;
K = 10;

W_line = circshift([ones(1,K+1), zeros(1,N-K-1)], [0, -floor(K/2)]);
W_line(1) = 0;
W = toeplitz(W_line);
W2 = SmallWorldRewire(W, 0.2);
W3 = SmallWorldProbRewire(W, 0.2);

figure(1);
imagesc(W);

figure(2);
imagesc(W2);

figure(3);
imagesc(W3);

figure(3);
imagesc(SmallWorldProbRewire(W, 0.2));

return

p_beta = 0.01;

data_sw = load('sw_3dim.mat');
W = data_sw.W;
W3 = SmallWorldProbRewire(W, p_beta);

% verify probility
tic; s=full(sum(W3(W(:)==1))); toc  # 8.74 sec
p0 = nnz(W)/(n*(n-1));
p_beta * (1-p0)
1 - s / nnz(W)

tic; t=full(sum(W(W3(:)==1)==0)); toc  # 8.76 sec
t / (n*(n-1) - nnz(W))
p_beta * p0


tic; id=randperm(n*(n-1), 56916000); toc  # 11.85 sec
Wr = sparse(n, n);
tic; Wr(id) = 1; toc #  sec >12hour

