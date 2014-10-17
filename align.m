function [] = align(min,max)

home = cd('./facedb');
bEyes = zeros(2,2);

for i = min:max
    file = [num2str(i) '.jpg'];
    img = imread(file);
    image(img); title(file)
    axis image
    
    %Get the point locations of the eyes
    [iEyes(1,1), iEyes(1,2)] = getpts;
    [iEyes(2,1), iEyes(2,2)] = getpts;
    
    %Set the base point locations for the eyes
    bEyes = [151 200; 250 200];
    tf = cp2tform(iEyes,bEyes,'nonreflective similarity');
    T = imtransform(img,tf,'XData',[101 300],'YData',[51 350]);
    facedb = cd(home);
    cd('./aligned');
    imwrite(T, file);
    cd(facedb);
end

cd(home);
end