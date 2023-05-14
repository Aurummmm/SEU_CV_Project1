function [H, corrPtIdx] = CalcH(pts1, pts2)

Points=[pts1.Location,pts2.Location];
coef.minPtNum = 4;
coef.iterNum = 50;
coef.thDist = 4;
coef.thInlrRatio = 0.1;
% ʹ��RANSAC�㷨������ŵ�H
%[H, corrPtIdx] = ransac(pts1, pts2, coef, @CalcHDetail, @calcDist);
%����任
if pts1.Count < coef.minPtNum
    H=0;
    corrPtIdx=false;
    return
end
[H, corrPtIdx] = ransac(Points,@CalcHDetail,@calcDist,4,4);
%h
end