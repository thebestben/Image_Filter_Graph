clear
close all
clc



%% load Image
[X,cmap] = imread('Test.png');
X1 = X(:,:,1);


%% Enter the Axes
Axes_input = inputdlg({'x1','x2','y1', 'y2'},...
    'Enter the numerical value of the coordinates you are going to click on',...
    [1 100; 1 100; 1 100 ; 1 100]);

Axes_click = readPoints('Test.png', 4);



%% Make four clicks around the shape of the data point

message = 'mark four clicks around the data point';
title = 'Mark shape';
uiwait(msgbox(message, title))
Shape_click = readPoints('Test.png', 4);

left = ceil(min(Shape_click(1,:)));
lower = ceil(max(Shape_click(2,:)));
right = ceil(max(Shape_click(1,:)));
upper = ceil(min(Shape_click(2,:)));


%% Show the shape of the data point
shape = X(upper:lower, left:right,:);
shape1 = shape(:,:,1);
imshow(shape,cmap)



%% Apply sliding mask
% load('Clicks.mat')

sizeShape = size(shape);

% What are possible centers
vert = ceil(sizeShape(1)/2);
hor = ceil(sizeShape(2)/2);

% Potential upper left
Vec = 1: numel(X(:,:,1));
PointsMat = zeros(size(X(:,:,1)));
PointsMat(1:end) = Vec;

PotentialUL = PointsMat(1:end-sizeShape(1), 1:end-sizeShape(2));

X1(X1==0) = 1;
X1(X1~=1) = 0;
shape1(shape1==0) = 1;
shape1(shape1~=1) = 0;

for i = 1:size(PotentialUL,1)
    for j = 1 : size(PotentialUL,2)
   
        FilterResult(i,j) = sum(shape1(:,:).*X1(i:i+sizeShape(1)-1,j:j+sizeShape(2)-1),'all');
        
    end
end


%% Welches Upper-left gehört zu welchem Mittelpunkt? 


%% Welche Koordinaten haben die Mittelpunkte?




%% Functions
function pts = readPoints(image, n)
%readPoints   Read manually-defined points from image
%   POINTS = READPOINTS(IMAGE) displays the image in the current figure,
%   then records the position of each click of button 1 of the mouse in the
%   figure, and stops when another button is clicked. The track of points
%   is drawn as it goes along. The result is a 2 x NPOINTS matrix; each
%   column is [X; Y] for one point.
%
%   POINTS = READPOINTS(IMAGE, N) reads up to N points only.
if nargin < 2
    n = Inf;
    pts = zeros(2, 0);
else
    pts = zeros(2, n);
end
imshow(image);     % display image
xold = 0;
yold = 0;
k = 0;
hold on;           % and keep it there while we plot
while 1
    [xi, yi, but] = ginput(1);      % get a point
    if ~isequal(but, 1)             % stop if not button 1
        break
    end
    k = k + 1;
    pts(1,k) = xi;
    pts(2,k) = yi;
    if xold
        plot([xold xi], [yold yi], 'go-');  % draw as we go
    else
        plot(xi, yi, 'go');         % first point on its own
    end
    if isequal(k, n)
        break
    end
    xold = xi;
    yold = yi;
end
hold off;
if k < size(pts,2)
    pts = pts(:, 1:k);
end
end