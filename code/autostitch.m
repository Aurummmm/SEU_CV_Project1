clear;
close all;
filename ='all1';
[bin,binsize,cell_H]=makeclass(filename);
img=imageDatastore(filename); 

%change(filename);
typename=cell([length(binsize),1]);
for i = 1:length(binsize)
    type_name=sprintf('type_%d',i);
    [status, message, messageid] = rmdir(type_name,'s');
    [status, msg, msgID] = mkdir(type_name);
    typename{i,1}=type_name;
    k = find(~(bin-i),binsize(i));
    fname=img.Files(k);
    cell_H0=cell(binsize(i));
    for n = 1:binsize(i)
        copyfile(fname{n},type_name);
        cell_H0={cell_H{k,k}};
        cell_H0=reshape(cell_H0,[binsize(i),binsize(i)]);
    end
    
    snitch(typename{i},cell_H0);
    pystitch(typename{i});
    %change(typename{i});
end

%%%%%%%%%%最小生成树idx = binsize(bin) >= 3;
% SG = subgraph(G, idx);
% plot(SG)
% T = minspantree(SG)
% 
% img=imageDatastore("all");
% Inow=readimage(img,1);
% numImages = numel(img.Files);
% tforms(numImages) = projtform2d;
% [H0,c0]=findH(Inow,Inow);
% tforms(1) = projtform2d(H0);
% imageSize = zeros(numImages,2);
% for n=2:numImages
%     Ipre=Inow;
%     Inow=readimage(img,n);
%     imageSize(n,:) = size(im2gray(Inow));
%     [H,c]=findH(readimage(img,n-1),readimage(img,n));
%     %H=findH(Ipre,Inow);
%     tforms(n) = projtform2d(H^-1);
%     tforms(n).A=tforms(n-1).A*tforms(n).A;
% end
% for i = 1:numel(tforms)           
%     [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);    
% end
% avgXLim = mean(xlim, 2);
% [~,idx] = sort(avgXLim);
% centerIdx = floor((numel(tforms)+1)/2);
% centerImageIdx = idx(centerIdx);
% Tinv = invert(tforms(centerImageIdx));
% for i = 1:numel(tforms)    
%     tforms(i).A = Tinv.A * tforms(i).A;
% end
% for i = 1:numel(tforms)           
%     [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);
% end
% 
% maxImageSize = max(imageSize);
% 
% % Find the minimum and maximum output limits. 
% xMin = min([1; xlim(:)]);
% xMax = max([maxImageSize(2); xlim(:)]);
% 
% yMin = min([1; ylim(:)]);
% yMax = max([maxImageSize(1); ylim(:)]);
% 
% % Width and height of panorama.
% width  = round(xMax - xMin);
% height = round(yMax - yMin);
% 
% % Initialize the "empty" panorama.
% panorama = zeros([height width 3], 'like', Inow);
% blender = vision.AlphaBlender('Operation', 'Binary mask', ...
%     'MaskSource', 'Input port');  
% 
% % Create a 2-D spatial reference object defining the size of the panorama.
% xLimits = [xMin xMax];
% yLimits = [yMin yMax];
% panoramaView = imref2d([height width], xLimits, yLimits);
% 
% % Create the panorama.
% for i = 1:numImages
% 
%     I = readimage(img, i);   
% 
%     % Transform I into the panorama.
%     warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);
% 
%     % Generate a binary mask.    
%     mask = imwarp(true(size(I,1),size(I,2)), tforms(i), 'OutputView', panoramaView);
% 
%     % Overlay the warpedImage onto the panorama.
%     panorama = step(blender, panorama, warpedImage, mask);
% end
% 
% figure
% imshow(panorama)