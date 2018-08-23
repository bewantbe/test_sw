%

addpath('/home/xyy/matcode/color_sci/');

%data_sw = load('2D-SW-Allihi-J_II=0.3000-ext_f=0.6000-ext_r=20.0000-2018-06-13_11_15_27.316322-1027.mat');

figy = figure('Color','white');
set(figy,'Unit','inch')
set(figy,'Position',[4,1,4,6.6])

O = data_sw.O;

m1 = 100;
m2 = 100;
O = reshape(O, [m1, m2]);

%figure(123);

h1 = subplot(2,1,1);
cla

%colormap(gray());

finterp = @(yval) interp1((0:3)/3, yval, linspace(0,1,64))';
vhue = [0.667 0.667 0.667 0.667];
vsat = [0 1/3 2/3 1];
vval = [1 1 1 1];
colormap(hsv2rgb([finterp(vhue), finterp(vsat), finterp(vval)]));

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
