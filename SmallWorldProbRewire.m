% SmallWorldRewire
% (1-p_beta), p_beta
% In population:
%   p_beta * ps + (1-p_beta)
% Out population:
%   p_beta * ps

function sw_net = SmallWorldProbRewire(lattice_net, p_beta)
  n = length(lattice_net);
  n_nz = nnz(lattice_net);
  p0 = n_nz/(n*(n-1));
  p_in = p_beta*(1-p0);
  p_out = p_beta*p0;

  %binoinv(1-1e-14, n*(n-1)-n_nz, p_out);  % very unlikely to exceed.
  normbnd = 7.64;  % 7.64 <-> p=1e-14
  n_exceed_max = min([round(normbnd*sqrt((n*(n-1)-n_nz)*p_out*(1-p_out))),...
                      n*(n-1)-n_nz]);

  % i-row, j-col, s-val for sw_net
  sw_i = zeros(n_nz + n_exceed_max, 1);
  sw_j = zeros(n_nz + n_exceed_max, 1);
  sw_s = zeros(n_nz + n_exceed_max, 1);
  sw_id = 1;
  % MATLAB sparse network stores in row major order, so we do it row-by-row.
  for k = 1:size(lattice_net, 1)
    row = lattice_net(k, :);
    [~,j,s] = find(row);
    n_nzc = length(j);
    % site of removal, in space 1:n_nzc
    bl_rewire = rand(1, n_nzc) < p_in;

    % pick attatch site
    n_out_pick = binornd(n-1-n_nzc, p_out);
    j_z_pick = randperm(n-1-n_nzc, n_out_pick);
    % Mapper into space 1:n, could be optimized.
    j_map = 1:n;
    j_map([j, k]) = [];

    j = [j(~bl_rewire), j_map(j_z_pick)];
    n_nzc = length(j);

    sw_i(sw_id:sw_id+n_nzc-1) = k;
    sw_j(sw_id:sw_id+n_nzc-1) = j;
    sw_s(sw_id:sw_id+n_nzc-1) = 1;
    sw_id = sw_id + n_nzc;
  end
  sw_net = sparse(sw_i(1:sw_id-1), sw_j(1:sw_id-1), sw_s(1:sw_id-1), n, n);
end

