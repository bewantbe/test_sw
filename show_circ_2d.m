%

addpath('/home/xyy/matcode/color_sci/');

data_sw = load('2D-SW-Allihi-J_II=0.3000-ext_f=0.6000-ext_r=20.0000-2018-06-13_11_15_27.316322-1027.mat');

O = data_sw.O;

m1 = 100;
m2 = 100;
O = reshape(O, [m1, m2]);

%figure(123);

h1 = subplot(2,1,1);
cla
colormap(inferno());
imagesc((0:m1-1)/(m1-1), (0:m2-1)/(m2-1), O);
axis equal
axis square
axis([0 1 0 1])
xlabel('x')
ylabel('y')
%print('-dpng', 'circ_2d.png')
set(gca,'Fontname','Arial','Fontsize',12)
set(gca,'Ytick',[0,0.5,1.0])

h2 = subplot(2,1,2);

%
%print('-dpdf', 'pic_tmp/view-2d-3d.pdf')
%print('-depsc2', 'pic_tmp/view-2d-3d.eps','-r600')
