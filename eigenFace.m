function [] = eigenFace(max)
MAX_EIG = 5;
home = cd('./aligned');
m = 300;
n = 200;
A = zeros(m*n,max+1);

avgI = rgb2gray(imread('average.jpg'));
avgD = im2double(avgI);

for i = 0:max
    file = [num2str(i) '.jpg'];
    img = rgb2gray(imread(file));
    d = im2double(img);
    d = d - avgD;
    
    A(:,i+1) = reshape(d,m*n,1);
end

U = zeros(m,n);
S = zeros(n,n);
V = zeros(n,n);

[U,S,V] = svd(A,0);

%Save the first five components of the eigen faces
cd(home);
cd('./Eigen');
for j = 1:MAX_EIG
    file = ['Eigen-' num2str(j) '.jpg'];
    col = U(:,j);
    eFace = reshape(col,m,n);
    eImg = mat2gray(eFace);
    imwrite(eImg, file);
end

VT = V';

X = VT(:,1);
Y = VT(:,2);

scatter(X,Y);

for j = 1:max
    Y(j) = S(j,j);
    X(j) = j;
end
scatter(X,Y)

scatter

cd(home);
end