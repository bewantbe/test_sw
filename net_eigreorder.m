%
% Usage:
% W = rand(281) < 0.04;
% W2 = [W2, idr] = net_eigreorder(W)

function [W2, idr] = net_eigreorder(w)

W = w;
W(eye(size(W))==1) = 0;
W = (W + W')>0;

Q = W - mean(W);
Sim = Q.' * Q;
[ev, ei] = eig(Sim);
coor = Sim * ev;
coor = coor(:, end-1:end);

ag = atan2(coor(:,2), coor(:,1));
[~, idr] = sort(ag);
W2 = w(idr, idr);

%figure(10);
%imagesc(W);

%figure(11);
%imagesc(W2);

%figure(13);
%scatter(coor(:,1), coor(:,2));

%figure(14);
%plot(diag(ei))

end
