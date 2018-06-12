%

n1 = 100;  % first dim
n2 = 100;  % second dim
n_r = 10;  % must even number
W_rg = -n_r/2:n_r/2;
[ax2, ax1] = meshgrid(W_rg, W_rg);
W_motif = sqrt(ax1 .^ 2 + ax2 .^ 2) <= n_r/2 * (1 + 2*eps);
W_motif(n_r/2+1, n_r/2+1) = 0;

W = zeros(n1*n2, n1*n2);

%W_motif_id = ax2 * n1 + ax1;
tic
for i1 = 1:n1
  for i2 = 1:n2
    W_motif_id_pos = mod(ax2+i2-1, n2) * n1 + mod(ax1+i1-1, n1);
    W_motif_id_pos = sort(W_motif_id_pos(W_motif));
    W(i1 + (i2-1)*n1, W_motif_id_pos + 1) = 1;
  end
end
toc

save('sw_2dim.mat', 'W');

absmod = @(a, b) mod(a + floor(b/2), b) - floor(b/2);

figure(10); imagesc(W);

for i1 = 1:n1
  for i2 = 1:n2
    for j1 = 1:n1
      for j2 = 1:n2
        b1 = W(i1 + (i2-1)*n1, j1 + (j2-1)*n1) == 1;
        b2 = sqrt(absmod(i1-j1,n1)^2 + absmod(i2-j2,n2)^2) <= n_r/2 * (1 + 2*eps) ...
             && ~(i1==j1 && i2==j2);
        if b1 ~= b2
          fprintf('i1, i2, j1, j2 = %d, %d, %d, %d\n', i1, i2, j1, j2);
          error('wtf')
        end
      end
    end
  end
end

