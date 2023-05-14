function [H,corrPtIdx]=findH(img1,img2)
% 利用SIFT算法找到匹配的特征点对并可视化
[des1, loc1, des2, loc2,p1,p2] = drawKeypoints(img1, img2);

% 计算符合粗筛选条件的特征匹配点对并可视化
%[matchLoc1, matchLoc2] = siftMatch(des1, loc1, des2, loc2);
indexPairs = matchFeatures(des1,des2,'Unique',true);
matchedPoints1 = p1(indexPairs(:,1),:);
matchedPoints2 = p2(indexPairs(:,2),:);
figure; 
showMatchedFeatures(img1,img2,matchedPoints1,matchedPoints2,"montag");
% % 输出所有的特征点对
% disp([matchLoc1, matchLoc2]);
% % 绘制由SIFT初步得到的粗特征匹配点连线
% drawLine1(img1, img2, matchLoc1, matchLoc2);

% 利用RANSAC算法计算出单应矩阵H以及最终的特征点下标corrPtIdx
[H, corrPtIdx] = CalcH(matchedPoints1,matchedPoints2);
% 显示单应矩阵
fprintf('单应矩阵H如下：\n');
disp(H);
% 显示由RANSAC找到的特征匹配点对在matchLoc矩阵的下标
fprintf('由RANSAC找到的特征匹配点对在matchLoc矩阵的下标如下：\n');
disp(corrPtIdx);
% 绘制由RANSAC最终得到的精特征匹配点连线
drawLine2(img1, img2, matchedPoints1.Location, matchedPoints2.Location, corrPtIdx)
end
% 利用单应矩阵将img2投影，使img2和img1在同一坐标系下，方便后续的拼接
% tform = projective2d(H);%(H');
% img2_adjusted = imwarp(img2, tform); 
% 显示一下两幅原始图像
% figure;
% imshow(img1);
% figure;
% imshow(img2_adjusted);
%%%%%%%%%%%%%%%%%%%%%%
%blender = vision.AlphaBlender;
