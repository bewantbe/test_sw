% SmallWorldRewire
% (1-p_beta), p_beta

function sw_net = SmallWorldRewire(lattice_net, p_beta)
  n = length(lattice_net);
  n_nz = nnz(lattice_net);
  p0 = n_nz/(n*(n-1));
  p_in = p_beta*(1-p0);
  % i-row, j-col, s-val for sw_net
  sw_i = zeros(n_nz, 1);
  sw_j = zeros(n_nz, 1);
  sw_s = zeros(n_nz, 1);
  sw_id = 1;
  % MATLAB sparse network stores in row major order, so we do it row-by-row.
  for k = 1:size(lattice_net, 1)
    row = lattice_net(k, :);
    [~,j,s] = find(row);
    n_nzc = length(j);
    % site of rewiring, in space 1:n_nzc
    bl_rewire = rand(1, n_nzc) < p_in;
    id_rewire = find(bl_rewire);
    n_rewire = length(id_rewire);

    % pick attatch site
    j_rewire2 = randperm(n-1-n_nzc+n_rewire, n_rewire);
    % convert to space 1:n
    j_map = 1:n;
    j_map([j(~bl_rewire), k]) = [];

    j(id_rewire) = j_map(j_rewire2);

    sw_i(sw_id:sw_id+n_nzc-1) = k;
    sw_j(sw_id:sw_id+n_nzc-1) = j;
    sw_s(sw_id:sw_id+n_nzc-1) = s;
    sw_id = sw_id + n_nzc;
  end
  sw_net = sparse(sw_i, sw_j, sw_s, n, n);
end

