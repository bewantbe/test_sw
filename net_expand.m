% push and expand net

%W = rand(10)<0.3;

W = w;

W = W + W.';
W(eye(size(W))==1) = 0;
n = length(W);

P = randn(2, n);

Fs = zeros(2, n);
Fp = zeros(2, n);

U = 1*(W>0);
for k = 1 : n
  U(U(:,k)>0, k) = k;
end
Ut = U.';

%soft_relu = @(x) (sqrt(x.^2+1)+x)/2;
%inv_soft_relu = @(y) y - 0.25 ./ y;

relu = @(x) max(0, x);

spring_force = @(r) 0.5 * relu(norm(r)-0.5) * (r / norm(r));
potential_force = @(r) 1 ./ norm(r).^2 * (-r / norm(r));
unit_dir = @(r) r / norm(r);

for id_t = 1 : 100
  % spring force
  for k = 1 : n
    r = P(:, W(k, :)>0) - P(:, k);
    Fs(:, k) = sum(spring_force(r), 2);
  end

  % Field force
  for k = 1 : n
    r = P(:, (1:n)~=k) - P(:, k);
    Fp(:, k) = sum(potential_force(r), 2);
  end

  mu = 0.01;

  % Move particals
  P = P + mu * (Fs + Fp);
  
  P = P - mean(P, 2);

  % Show particals
  figure(325)
  scatter(P(1,:), P(2,:));

  X = [P(1, U(U>0)); P(1,Ut(U>0))];
  Y = [P(2, U(U>0)); P(2,Ut(U>0))];
  line(X, Y);
  title(sprintf('id_t = %d', id_t));
  
%  pause
end

%
figure(13);
imagesc(W);

figure(324);
ag = angle(P(1, :) + 1i * P(2, :));
[~, ids] = sort(ag);
spy(W(ids, ids));

