%

addpath('celegan')

dealwith_NeuronConnect;

figure(1);
spy(w)

w2 = net_eigreorder(w);

figure(2435);
spy(w2);

ids = 1 : length(w2);
ids = circshift(ids, -87);
w3 = w2(ids, ids);

figure(324);
spy(w3);

save('-ascii', 'w.txt', 'w');

q = rand(5);
save('-ascii', 'q.txt', 'q');

