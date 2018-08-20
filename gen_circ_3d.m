%

n1 = 30;  % first dim
n2 = 30;  % second dim
n3 = 30;  % third dim

n_rg = 16;  % Full range of interaction, must even number.

W_rg = -n_rg/2:n_rg/2;
[gid1, gid2, gid3] = ndgrid(W_rg, W_rg, W_rg);
W_motif = sqrt(gid1 .^ 2 + gid2 .^ 2 + gid3 .^ 2) <= n_rg/2 * (1 + 2*eps);
W_motif(n_rg/2+1, n_rg/2+1, n_rg/2+1) = 0;

% The connectivity matrix
W = zeros(n1*n2*n3, n1*n2*n3);

%W_motif_id = ax3 * n1 * n2 + ax2 * n1 + ax1;
tic
for i1 = 1:n1
  for i2 = 1:n2
    for i3 = 1:n3
      W_motif_id_pos = ...
        mod(gid3+i3-1, n3)*n1*n2 + mod(gid2+i2-1, n2)*n1 + mod(gid1+i1-1, n1);
      W_motif_id_pos = sort(W_motif_id_pos(W_motif));
      W(i1 + (i2-1)*n1 + (i3-1)*n1*n2, W_motif_id_pos + 1) = 1;
    end
  end
end
toc

W = sparse(W);

save('-v7.3', 'sw_3dim.mat', 'W', 'n1', 'n2', 'n3', 'n_rg');

return

% verify
absmod = @(a, b) mod(a + floor(b/2), b) - floor(b/2);

figure(10); imagesc(W);

for i1 = 1:n1
  for i2 = 1:n2
    for i3 = 1:n3
      for j1 = 1:n1
        for j2 = 1:n2
          for j3 = 1:n3
            b1 = W(i1+(i2-1)*n1+(i3-1)*n1*n2, j1+(j2-1)*n1+(j3-1)*n1*n2) == 1;
            b2 = sqrt(absmod(i1-j1,n1)^2 + absmod(i2-j2,n2)^2 + absmod(i3-j3,n3)^2) ...
                  <= n_rg/2 * (1 + 2*eps) ...
                  && ~(i1==j1 && i2==j2 && i3==j3);
            if b1 ~= b2
              fprintf('i1, i2, i3, j1, j2, j3 = %d, %d, %d, %d, %d, %d\n', i1, i2, i3, j1, j2, j3);
              error('wtf')
            end
          end
        end
      end
    end
  end
end
disp('wahh');

