function [H, corrPtIdx] = CalcH(pts1, pts2)

Points=[pts1.Location,pts2.Location];
coef.minPtNum = 4;
coef.iterNum = 50;
coef.thDist = 4;
coef.thInlrRatio = 0.1;
% 使用RANSAC算法求解最优的H
%[H, corrPtIdx] = ransac(pts1, pts2, coef, @CalcHDetail, @calcDist);
%仿射变换
if pts1.Count < coef.minPtNum
    H=0;
    corrPtIdx=false;
    return
end
[H, corrPtIdx] = ransac(Points,@CalcHDetail,@calcDist,4,4);
%h
end