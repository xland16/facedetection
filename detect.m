function [] = detect(file, tau, scale)

% Get the average face and store it
home = cd('./aligned');
temp = imread('average.jpg');

% Get the target image to detect faces in
cd(home);
cd('./target');
I = imread(file);

% Convert to double and normalize
img = im2double(I)/255;

% Get the red, green, and blue components of the target image
Sr = img(:,:,1);
Sg = img(:,:,2);
Sb = img(:,:,3);

[Sm Sn] = size(Sr);
cd(home);

% Have a matrix of all zeros to easily flag when a pixel could be a "face
% point"
facePts = zeros(Sm,Sn);

% Resize template, convert to double and normalize it
timg = im2double(imresize(temp,scale))/255;

% Get the red, green, and blue components of the template image    
Tr = timg(:,:,1);
Tg = timg(:,:,2);
Tb = timg(:,:,3);
[Tm Tn] = size(Tr);

% Get SSD's for each color intensity and normalize them to be <= 1
SSDr = normalize(getSSD(Sr,Tr));
SSDg = normalize(getSSD(Sg,Tg));
SSDb = normalize(getSSD(Sb,Tb));

% Average the intensities
SSD = (SSDr + SSDg + SSDb)/3;

% Debug check to find min SSD
amin = min(min(SSD))

% Loop through image and flag potential "face points"
for m = 1:Sm
    for n = 1:Sn
        if SSD(m,n) < tau;
            facePts(m,n) = 1;
        end
    end
end

% Nonmaximal surpression
for m = 1:Sm
    for n = 1:Sn
        if facePts(m,n) == 1
            [m_l,m_h,n_l,n_h] = getNDim(m,n,Sm,Sn,uint16(Tm/2),uint16(Tn/2));
            % Cycle through neighborhood of half the template size and
            % suppress near values that are larger than current pixel's
            for i = m_l:m_h
                for j = n_l:n_h    
                    if SSD(i,j) > SSD(m,n)
                        facePts(i,j) = 0;
                    end
                end
            end
        end
    end
end

% Draw a box around the face where the box dimensions are the size of the
% template
for m = 1:Sm
    for n = 1:Sn
        if facePts(m,n) == 1
            [m_l m_h n_l n_h] = getNDim(m,n,Sm,Sn,uint16(Tm/2),uint16(Tn/2));
            for i = m_l:m_h
                I(i,n_l,1)=0;
                I(i,n_l,2)=255;
                I(i,n_l,3)=0;
                I(i,n_h,1)=0;
                I(i,n_h,2)=255;
                I(i,n_h,3)=0;
            end
            for i = n_l:n_h
                I(m_l,i,1)=0;
                I(m_l,i,2)=255;
                I(m_l,i,3)=0;
                I(m_h,i,1)=0;
                I(m_h,i,2)=255;
                I(m_h,i,3)=0;
            end 
        end
    end
end

imshow(I)

% Save images
cd('./detected');
params = ['-' num2str(tau) '-' num2str(scale) '-'];
nfile = strrep(file, '.jpg', '');
g = mat2gray(SSD);

imwrite(I,[nfile params 'detect.jpg']);
imwrite(g,[nfile params 'facepts.jpg']);
cd(home);
end