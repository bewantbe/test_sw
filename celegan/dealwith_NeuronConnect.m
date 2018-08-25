%

[A,B,C]= xlsread('NeuronConnect.xls');
T = unique(C(:,1));
T(130) = [];
K = cell(281,2);
K(:,1) = T;
for i = 1 : 281
    K{i,2} = i;
end
T = K;
clear K


C_nmj = 0;
w = zeros(281);
for i = 1 : 6417
    if strcmp('S',C{i+1,3})
        w(T{strcmp(T(:,1),C{i+1,2}),2},T{strcmp(T(:,1),C{i+1,1}),2}) = 1;
    elseif strcmp('Sp',C{i+1,3})
        w(T{strcmp(T(:,1),C{i+1,2}),2},T{strcmp(T(:,1),C{i+1,1}),2}) = 1;
    elseif strcmp('R',C{i+1,3})
        w(T{strcmp(T(:,1),C{i+1,1}),2},T{strcmp(T(:,1),C{i+1,2}),2}) = 1;
    elseif strcmp('Rp',C{i+1,3})
        w(T{strcmp(T(:,1),C{i+1,1}),2},T{strcmp(T(:,1),C{i+1,2}),2}) = 1;
    elseif strcmp('EJ',C{i+1,3})
        w(T{strcmp(T(:,1),C{i+1,2}),2},T{strcmp(T(:,1),C{i+1,1}),2}) = 1;
        w(T{strcmp(T(:,1),C{i+1,1}),2},T{strcmp(T(:,1),C{i+1,2}),2}) = 1;
%    elseif strcmp('NMJ',C{i+1,3})
%        w(T{strcmp(T(:,1),C{i+1,2}),2},T{strcmp(T(:,1),C{i+1,1}),2}) = 1;
%        w(T{strcmp(T(:,1),C{i+1,1}),2},T{strcmp(T(:,1),C{i+1,2}),2}) = 1;
%        C_nmj = C_nmj + 1;
    end
end
%%
%figure(111)
%spy(w);


%figure(234); 
%% ii = symrcm(w);
%% ii= symamd(w);
%ii= amd(w);
%% ii = colperm(w);
%ww = w(ii,ii);
%spy(w(ii,ii));


%%%
%%W = 1*((w + w')>0);
%W = 1*(w >0);
%id = true(length(w), 1);
%id([122 123 149 154]) = false;
%wf = W(id,id);
%d = graphallshortestpaths(wf);
%% max(d(:))
%% [~,idf] = max(d(:))
%figure(789432)
%imagesc(isinf(d))
