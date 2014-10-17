function [] = avgFace(min,max)

home = cd('./aligned');

avg = zeros(300,200,3);
s = 1/(max-min+1);

for i = min:max
    file = [num2str(i) '.jpg'];
    img = imread(file);
    d = double(img);
    d = s*d;
    avg = avg + d;
end

A = uint8(avg);
imwrite(A,'average.jpg');
cd(home);
end