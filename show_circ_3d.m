%

load('ISI_sw_3d_ei.mat')
pm = pm0;

[gx1, gx2, gx3] = ndgrid(1:n1, 1:n2, 1:n3);

if exist('cnt', 'var')
  rate = cnt(1:pm.nI);
else
  rate = 1000 ./ ISI(1:pm.nI);
end
rate = reshape(rate, size(gx1));

rate = circshift(rate, [0 4 2]);
cla
switch 5
  case 0
    figure(12)
    rate = (~isnan(rate) & rate > 10)*10;
    rate(rate==0) = nan;
    scatter3(gx1(:), gx2(:), gx3(:), rate(:));
    camproj('perspective')
    axis('square')

  case 1
    figure(13)
    rate(rate==0) = nan;
    scatter3(gx1(:), gx2(:), gx3(:), rate(:));
    camproj('perspective')
    axis('square')

  case 2
    figure(14);
    gx1  = permute(gx1, [2,1,3]);
    gx2  = permute(gx2, [2,1,3]);
    rate = permute(rate, [2,1,3]);
    contourslice(gx1, gx2, gx3, rate, [], [14 15 16], []);
    camproj('perspective')
    axis('equal')

  case 3
    % not work
    figure(15);
    gx1  = permute(gx1, [2,1,3]);
    gx2  = permute(gx2, [2,1,3]);
    rate = permute(rate, [2,1,3]);
    contour3(gx1, gx2, gx3, rate);
    camproj('perspective')
    axis('equal')

  case 4
    figure(17);
    gx1  = permute(gx1, [2,1,3]);
    gx2  = permute(gx2, [2,1,3]);
    rate = permute(rate, [2,1,3]);
    val = 20;
    isosurface(gx1, gx2, gx3, rate, val);
    camproj('perspective')
    axis('equal')

  case 5
%    figure(18);
%    cla
    gx1  = permute(gx1, [2,1,3]) / n1;
    gx2  = permute(gx2, [2,1,3]) / n2;
    gx3  = gx3 / n3;
    rate = permute(rate, [2,1,3]);
    val = 10;
    p = patch(isosurface(gx1, gx2, gx3, rate, val));
    isonormals(gx1, gx2, gx3, rate, p)
    
    % Compute color based on depth.
    [az, el] = view();
    view_normal = -[sin(az/180*pi)*cos(el/180*pi); -cos(az/180*pi)*cos(el/180*pi); sin(el/180*pi)];
    depth = p.Vertices * view_normal;
    depth = (depth - min(depth)) / (max(depth)-min(depth));
    fhue = @(x) interp1([0 0.5 1], [0.6 0.667 0.7], x);
    fsat = @(x) interp1([0 0.5 1], [1 1 0], x);
    fval = @(x) interp1([0 0.5 1], [1 1 0], x);
    hsvc = [fhue(depth), fsat(depth), fval(depth)];
    
    p.FaceVertexCData = hsv2rgb(hsvc);
    p.FaceColor = 'interp'; % [0 0 1];
    p.EdgeColor = 'none';

    % Compute transparency based on focus.
    ftrans = @(x) 1-(1-exp(-10*(x))).^20;
    p.FaceVertexAlphaData = ftrans(sqrt(sum((p.Vertices - [1 1 1]/2).^2,2)));
    p.FaceAlpha = 'interp';  % 0.7
    
    daspect([1 1 1]);
    axis([0 1 0 1 0 1])
    xlabel('x')
    ylabel('y')
    zlabel('z')
    set(gca,'Fontname','Arial','Fontsize',12)
    
    camlight
    camlight
    lighting gouraud  % gouraud phong
    camproj('perspective')
    
    if exist('h2', 'var')
      set(h2,'Position', [0.22 0.05 0.62 0.5])
    end
    print('-dpng', 'pic_tmp/view-3d-v2.png')
    print('-depsc2', 'pic_tmp/view-3d-v2.eps', '-r600')

  case 6
    gx1  = permute(gx1, [2,1,3]);
    gx2  = permute(gx2, [2,1,3]);
    rate = permute(rate, [2,1,3]);

    kf = 1;
    [gx1e, gx2e, gx3e] = meshgrid(1:n1*kf, 1:n2*kf, 1:n3*kf);
    gx1e = gx1e / kf;
    gx2e = gx2e / kf;
    gx3e = gx3e / kf;
    ratee = interp3(gx1, gx2, gx3, rate, gx1e, gx2e, gx3e, 'makima');  % 'spline'
%    ratee = interp3(rate, kf);

    try
      close(19)
    catch
    end
    figure(19);

%    x = n1*[0.8 0.7 0.6 0.7];
%    y = n2*[0 1 1 0];
%    z = n3*[0 0 1 1];
%    colormap('gray')
%    patch(x, y, z, [1 1 1 1]);
%    alpha(0.4)

    val = 7;
    p = patch(isosurface(gx1e, gx2e, gx3e, ratee, val));
    isonormals(gx1e, gx2e, gx3e, ratee, p)
    p.FaceColor = 'blue';
    p.EdgeColor = 'none';
    alpha(0.7)

    daspect([1 1 1]);
    view(3);
    axis tight
    
    camlight
    lighting gouraud
    camproj('perspective')
    axis('equal')
%    print('-dpng', 'pic_tmp/view-3d.png')
%    view([5,-1,0])
%    print('-dpng', 'pic_tmp/view-left.png')
%    view([5,1,0])
%    print('-dpng', 'pic_tmp/view-right.png')
end

%figure(21);
%imagesc(ratee(:,:,2))

%figure(20);
%imagesc(rate(:,:,1))

%figure(20)
%for k = 1 : size(rate,3)
%  imagesc(rate(:,:,k))
%  print('-dpng', sprintf('pic_tmp/slice_%0.2d.png', k));
%end
% ffmpeg -framerate 8 -pattern_type glob -i '*.png' -c:v libx264 out.mp4

