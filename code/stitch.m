function snitch(file_name,cell_H)
img=imageDatastore([file_name]);
Inow0=readimage(img,1);
numImages = numel(img.Files);
tforms(numImages) = projtform2d;
flag=true;
%[H0,c0]=findH(Inow,Inow);
for i =1:numImages
    for j= 1:numImages
        if isempty(cell_H{i,j})
            flag = false;
        end
    end
    if flag
        break
    end
    flag=true;
end
H0=cell_H{1,i};
tforms(1) = projtform2d(H0);
imageSize = zeros(numImages,2);
for n=2:numImages
    Ipre=Inow0;
    Inow=readimage(img,n);
    imageSize(n,:) = size(im2gray(Inow));
    %[H,c]=findH(readimage(img,n-1),readimage(img,n));
    H=cell_H{n,i};
    %H=findH(Ipre,Inow);
    tforms(n) = projtform2d(H);%^-1);
    %tforms(n).A=tforms(n-1).A*tforms(n).A;
end
for i = 1:numel(tforms)           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);    
end
avgXLim = mean(xlim, 2);
[~,idx] = sort(avgXLim);
centerIdx = floor((numel(tforms)+1)/2);
centerImageIdx = idx(centerIdx);
Tinv = invert(tforms(centerImageIdx));
for i = 1:numel(tforms)    
    tforms(i).A = Tinv.A * tforms(i).A;
end
for i = 1:numel(tforms)           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);
end

maxImageSize = max(imageSize);
%maxImageSize = sum(imageSize);

% Find the minimum and maximum output limits. 
xMin = min([1; xlim(:)]);
xMax = max([maxImageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([maxImageSize(1); ylim(:)]);

% Width and height of panorama.
width  = round(xMax - xMin);
height = round(yMax - yMin);

% Initialize the "empty" panorama.
panorama = zeros([height width 3], 'like', Inow);
%blender = vision.AlphaBlender('Operation','Blend','MaskSource', 'Input port');  
blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');  

xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

% Create the panorama.
for i = 1:numImages
    
    I = readimage(img, i);   
   
    % Transform I into the panorama.
    warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);
                  
    % Generate a binary mask.    
    mask = imwarp(true(size(I,1),size(I,2)), tforms(i), 'OutputView', panoramaView);
    
    % Overlay the warpedImage onto the panorama.
    %panorama = step(blender, panorama, warpedImage);%,mask);
    panorama = step(blender, panorama, warpedImage, mask);
end

figure
imshow(panorama)

end

