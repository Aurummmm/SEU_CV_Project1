function [bin,binsize,cell_H]=makeclass(filename)
img=imageDatastore([filename]);
%I=zeros(size(img.Files));
num_img=length(img.Files);
features_list=cell([length(img.Files),1]);
K=100;
Graph_classify=zeros([num_img,num_img]);
cell_H=cell(num_img);
points_list=cell([num_img,1]);
% Read the first image from the image set.
for i = 1:length(img.Files)
    I= readimage(img,i);
    % Initialize features for I(1)
    grayImage = im2gray(I);
    points = detectSIFTFeatures(grayImage);
    [features, points] = extractFeatures(grayImage,points);
    n = 1000;
    %random_features = features(randperm(points.Count,n),:);
    %random_num = sort(random_num);
    %random_features=reshape(random_features,[1,n*128]);
    features_list{i,1}=features;
    points_list{i,1}=points;
end

for i = 1:length(img.Files)
    for j = 1:length(img.Files)
        [a,b]=matchFeatures(features_list{i,1},features_list{j,1},'MaxRatio',0.2);
        p1=points_list{i,1};
        p2=points_list{j,1};
        matchedPoints1 = p1(a(:,1),:);
        matchedPoints2 = p2(a(:,2),:);
        num_match=numel(a)/2;
        K=0.01/128*max([numel(features_list{i,1}),numel(features_list{j,1})]);%0.01*(numel(features_list{i,1})+numel(features_list{j,1}))/2/128;
        if num_match>K
            [H, corrPtIdx] = CalcH(matchedPoints1,matchedPoints2);
            table = tabulate(corrPtIdx);
            if table{end,3}>10
                cell_H{i,j}=H;
                Graph_classify(i,j)=1;
            end
        end

    end

end
G = graph(Graph_classify,'upper');
plot(G,'Layout','layered');
[bin,binsize] = conncomp(G,'Type','weak');
%features_list=zeros([n,128,length(img.Files)]);
%features_list=cell2mat(features_list);
